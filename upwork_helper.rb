module UpworkApiWrapper
  def client
    config = Upwork::Api::Config.new(
      'consumer_key'    => ENV['CONSUMER_KEY'],
      'consumer_secret' => ENV['CONSUMER_SECRET'],
      'access_token'    => ENV['ACCESS_TOKEN'],
      'access_secret'   => ENV['ACCESS_SECRET']
      # 'debug'         => false
    )
    if !config.access_token and !config.access_secret
      # authz_url = client.get_authorization_url
      # for web-based applications you need to specify the exact oauth_callback explicitly
      # authz_url = client.get_authorization_url "https://my-callback-url-here.com"
      #puts "Visit the authorization url and provide oauth_verifier for further authorization"
      verifier = gets.strip
      @token = client.get_access_token(verifier)
      # store access token data in safe place!
    end
    Upwork::Api::Client.new(config)
  end

  def auth
    Upwork::Api::Routers::Auth.new(client)
  end

  def report
    Upwork::Api::Routers::Reports::Time.new(client)
  end
end