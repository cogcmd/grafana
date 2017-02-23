require 'cog_cmd/grafana'
require 'grafana/command'
require 'active_support/all'

module CogCmd::Grafana
  class Panels < Grafana::Command
    def run_command
      panels = client.panels(dashboard_slug)
                     .map { |p| p["slug"] = p["title"].parameterize; p }
                     .sort_by { |p| p["slug"] }

      response.template = 'panels'
      response.content = panels
    end

    def dashboard_slug
      request.args[0]
    end
  end
end
