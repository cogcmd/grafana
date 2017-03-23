require 'httparty'
require 'aws-sdk'
require 'securerandom'
require 'active_support/all'

class Grafana::Client
  include HTTParty

  attr_reader :api_key

  base_uri ENV['GRAFANA_URL']

  def initialize(api_key)
    @api_key = api_key
    @s3_client = Aws::S3::Client.new(region: "us-east-1")
  end

  def dashboards
    get("/api/search")
  end

  def dashboard(slug)
    get("/api/dashboards/db/#{slug}")["dashboard"]
  end

  def panels(dashboard_slug)
    dashboard(dashboard_slug)["rows"].flat_map { |r| r["panels"] }
  end

  def graph(dashboard_slug, panel_id)
    query = {from: 1.hour.ago.to_i,
             to: Time.now.to_i,
             panelId: panel_id,
             width: 800,
             height: 600}

    image = get("/render/dashboard-solo/db/#{dashboard_slug}", query).body
    url = write_to_s3(image)
    {url: url}
  end

  private

  def get(uri, query = {})
    self.class.get(uri, { query: query, headers: headers })
  end

  def headers
    { "Authorization" => "Bearer #{api_key}" }
  end

  def write_to_s3(image_data)
    bucket = ENV["GRAFANA_S3_BUCKET"]
    key = "#{ENV["GRAFANA_S3_PATH"]}/#{SecureRandom.uuid}.png"

    @s3_client.put_object({acl: "public-read",
                           body: image_data,
                           bucket: bucket,
                           key: key})

    "https://s3.amazonaws.com/#{bucket}/#{key}"
  end
end
