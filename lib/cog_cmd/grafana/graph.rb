require 'cog_cmd/grafana'
require 'grafana/command'
require 'active_support/all'

module CogCmd::Grafana
  class Graph < Grafana::Command
    def run_command
      panel = client.panels(dashboard_slug)
                    .find { |p| p["title"].parameterize == panel_slug }

      graph = client.graph(dashboard_slug, panel["id"])

      response.content = graph
    end

    private

    def dashboard_slug
      request.args[0]
    end

    def panel_slug
      request.args[1]
    end
  end
end
