# repository-importer

Script to get all archival records for a repository and build an importable JSON file.

## Version

It is recommended that source and target instances of ArchivesSpace use the same version.

Currently tested version: v1.5.3.

## Export usage:

```bash
./export.sh <source backend URL> <source repo id> <username> <password>
```

## Import usage:

```bash
./import.sh <target backend URL> <target repo id> <username> <password> <file to import>
```

## Classification terms (v1.5.3 issue)

If your source database has classification terms add this to
`plugins/local/backend/plugin_init.rb` for the **target** instance:

```ruby
class StreamingImport

  # adding rec['classification'] for set_key variable
  def load_dependencies
    puts "\n\n\n\n\n"
    puts "MONKEY PATCHING LOAD DEPENDENCIES!"
    puts "\n\n\n\n\n"

    dependencies = DependencySet.new
    position_offsets = {}

    @ticker.tick_estimate = @jstream.count

    position_maps = {}

    @jstream.each do |rec|

      # Add this record's references as dependencies
      extract_logical_urls(rec, @logical_urls).each do |dependency|
        unless dependency == rec['uri']
          dependencies.add_dependency(rec['uri'], dependency)
        end
      end

      check_for_invalid_external_references(rec, @logical_urls)

      if rec['position']
        pos = rec['position']
        set_key = (
          rec['parent'] || rec['resource'] || rec['digital_object'] || rec['classification']
        )['ref']
        position_maps[set_key] ||= []
        position_maps[set_key][pos] ||= []
        position_maps[set_key][pos] << rec['uri']

      end

      @ticker.tick
    end

    position_maps.each do |set_key, positions|
      offset = 0
      positions.flatten!
      positions.compact!
      while !positions.empty?
        preceding = positions.shift
        following = positions[0]

        unless positions.empty?
          dependencies.add_dependency(following, preceding)
        end
      end
    end

    return dependencies, position_offsets
  end

end
```

Remove this patch after the import has completed. Alternatively, you could
delete "classifications" from the list of "records_to_import" in
`exporter.rb` if you're ok with not transferring the classifications.

---