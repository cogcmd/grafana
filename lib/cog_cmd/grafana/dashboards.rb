require 'cog_cmd/grafana'
require 'grafana/command'

module CogCmd::Grafana
  class Dashboards < Grafana::Command
    def run_command
      dashboards = client.dashboards
                         .map { |d| d["slug"] = d["uri"].gsub(/^db\//, ""); d }
                         .sort_by { |d| d["slug"] }

      response.template = 'dashboards'
      response.content = dashboards
    end
  end
end
