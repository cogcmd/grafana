class Grafana::Client
  attr_reader :client

  def initialize(api_key)
    @client = Grafana::Client.new(api_key)
  end

end
