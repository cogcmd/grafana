require 'cog/command'
require 'grafana'
require 'grafana/client'

class Grafana::Command < Cog::Command
  def client
    require_api_key!
    @client ||= Grafana::Client.new(api_key)
  end

  def api_key
    ENV['GRAFANA_API_KEY']
  end

  def require_api_key!
    unless api_key
      raise(Cog::Error, "`GRAFANA_API_KEY` not set.")
    end
  end
end
