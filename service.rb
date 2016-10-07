require 'net/http'
require 'uri'
require 'json'

class Service

  def initialize(backend_url, repo_id, username, password)
    @backend_url = backend_url
    @repo_id = repo_id
    @username = username
    @password = password
    @session = login!
  end


  def get_ids_for_type(record_type)
    get_json("#{repo_uri}/#{plural(record_type)}", {
      :all_ids => true
    })
  end


  def get_record(uri)
    get_json(uri)
  end


  def get_records_for_type(record_type, ids)
    get_json("#{repo_uri}/#{plural(record_type)}", {
      'id_set[]' => ids
    })
  end


  def repo_uri
    "/repositories/#{@repo_id}"
  end


  private


  def get_json(path, params = {})
    response = get(path, params)
    JSON.parse(response.body)
  end

  def get(path, params = {})
    request = Net::HTTP::Get.new(build_url(path, params))

    do_http_request(request)
  end



  def do_http_request(request)
    url = request.uri

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true if url.scheme == 'https'

    request['X-ArchivesSpace-Session'] = @session

    http.request(request)
  end


  def login!
    path = "/users/#{@username}/login"

    url = build_url(path)

    request = Net::HTTP::Post.new(url)
    request.form_data = {:password => @password, :expiring => false}

    response = do_http_request(request)

    if response.code != '200'
      raise LoginFailedException.new("#{response.code}: #{response.body}")
    end

    @session = JSON(response.body).fetch('session')

    @session
  end

  def build_url(path, params = {})
    result = URI.join(@backend_url, path)
    result.query = URI.encode_www_form(params)
    result
  end

  def plural(record_type)
    "#{record_type}s"
  end
end