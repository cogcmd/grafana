require 'cog_cmd/grafana'
require 'grafana/command'

module CogCmd::Grafana
  class Dashboards < Grafana::Command
    def run_command
      response.content = formatted_dashboards
    end

    def dashboards
      client.dashboards
        .map { |d| d["slug"] = d["uri"].gsub(/^db\//, ""); d }
        .sort_by { |d| d["slug"] }
    end

    def formatted_dashboards
      slugs = Array.new
      if tag.nil?
        dashboards.each{|db| slugs.push(db["slug"]) }
      else
        tagged_dashboards = dashboards.select{|db| db["tags"].include? tag.to_s }
        tagged_dashboards.each{|db| slugs.push(db["slug"]) }
        if slugs.empty? then slugs = "Sorry no dashboards under that tag." end
      end
      return slugs.to_json
    end

    def tag
      request.args[0]
    end
  end
end
