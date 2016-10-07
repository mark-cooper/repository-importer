require_relative 'service'
require 'securerandom'

def show_usage
  raise "Usage: #{$0} <backend URL> <repo id> <username> <password>"
end

$backend_url = ARGV.fetch(0) { show_usage }
$repo_id = ARGV.fetch(1) { show_usage }
$user = ARGV.fetch(2) { show_usage }
$password = ARGV.fetch(3) { show_usage }

$basedir = File.expand_path(File.join(File.dirname(__FILE__)))

@service = Service.new($backend_url, $repo_id, $user, $password)

export_file = File.join($basedir, "exported_#{Time.now.to_i}.json")

@exported_uris = []
@linked_uris = []

def prepare_record_for_export(record)
  record.delete('id')
  record.to_json
end

def extract_links(hash_or_array)
  uris = []

  if hash_or_array.kind_of? Array
    hash_or_array.map{|v|
      uris = uris.concat(extract_links(v))
    }
  elsif hash_or_array.kind_of? Hash
    hash_or_array.each do |k, v|
      if v.kind_of? Array
        uris = uris.concat(extract_links(v))
      elsif v.kind_of? Hash
        uris = uris.concat(extract_links(v))
      elsif k == 'ref'
        uris << v
      end
    end
  end

  uris
end

File.open(export_file, "w") do |out|
  out.puts("[")

  records_to_import = ['resource', 'archival_object', 'digital_object', 'digital_object_component', 'accession', 'classification']

  records_to_import.each do |record_type|
    p "-- Get all of type: #{record_type}"
    ids = @service.get_ids_for_type(record_type)
    ids.each_slice(50).each do |id_set|\
      p id_set
      records = @service.get_records_for_type(record_type, id_set)

      records.map {|record|
        @exported_uris << record['uri']
        extract_links(record).each do |uri|
          unless @exported_uris.include?(uri)
            @linked_uris << uri
          end
        end

        out.puts(prepare_record_for_export(record))
      }
      out.puts ","
    end
  end

  while(true)

    @linked_uris.clone.each do |uri|
      if @exported_uris.include?(uri) || uri == @service.repo_uri || uri =~ /tree/
        @linked_uris.delete(uri)
        next
      end

      p "-- linked record: #{uri}"

      record = @service.get_record(uri)
      @exported_uris << record['uri']
      @linked_uris.delete(record['uri'])

      extract_links(record).each do |uri|
        unless @exported_uris.include?(uri)
          @linked_uris << uri
        end
      end

      out.puts(prepare_record_for_export(record))
    end

    break if @linked_uris.empty?

    p "-- #{@linked_uris.length} linked records to go"
  end


  out.puts "]"
end

file_contents = File.read(export_file)
@exported_uris.each do |uri|
  import_uri = uri.clone.gsub(/\d+$/, "import_#{SecureRandom.hex}")
  p "Change #{uri} to #{import_uri}"
  file_contents.gsub!(/#{uri}/, import_uri)
end
file_contents.gsub!(/#{@service.repo_uri}/, "/repositories/REPO_ID_GOES_HERE")
File.open(export_file, "w") {|file| file.puts file_contents }

p "--"
p "-- Output file: #{export_file}"
