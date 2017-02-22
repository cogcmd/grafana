require 'grafana/command'

module CogCmd::Grafana
  class Graph < Grafana::Command
    def run_command
      response.content = {}
    end
  end
end
