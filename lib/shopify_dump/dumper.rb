# frozen_string_literal: true

require "logger"
require "net/http"
require "shopify_api"

class ShopifyDump::Dumper
  API_KEY = ENV["API_KEY"]
  PASSWORD = ENV["PASSWORD"]
  SHOP_NAME = ENV["SHOP_NAME"]
  API_VERSION = ENV["API_VERSION"]

  def initialize
    ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}@#{SHOP_NAME}.myshopify.com"
    ShopifyAPI::Base.api_version = API_VERSION
    @client = ShopifyAPI::GraphQL.client
    @logger = Logger.new(STDOUT)
  end

  def dump(query, file_suffix = "")
    # start bulk operation
    start_bulk_operation(query)
    # download jsonl file
    download_jsonl(fetch_download_url, file_suffix)
  end

  private

  def start_bulk_operation(query)
    @client.query(
      @client.parse(<<~"GRAPHQL")
        mutation {
          bulkOperationRunQuery(
            query:"""
            #{query}
            """
          ) {
            bulkOperation {
              id
              status
            }
            userErrors {
              field
              message
            }
          }
        }
      GRAPHQL
    )
  end

  def fetch_download_url
    i = 0
    while result = current_bulk_operation
      if result.to_h["data"]["currentBulkOperation"]["status"] == "COMPLETED"
        return result.to_h["data"]["currentBulkOperation"]["url"]
      elsif result.to_h["data"]["currentBulkOperation"]["status"] == "RUNNING"
        i += 10
        sleep(i)
      else
        @logger.warn("Bulk operation not running. " \
                     "Result:#{result.to_h["data"]["currentBulkOperation"]}")
        break
      end
    end
  end

  def current_bulk_operation
    @client.query(
      @client.parse(<<-'GRAPHQL')
        {
          currentBulkOperation {
            id
            status
            errorCode
            createdAt
            completedAt
            objectCount
            fileSize
            url
            partialDataUrl
          }
        }
      GRAPHQL
    )
  end

  def download_jsonl(url, file_suffix)
    open("shopify_#{file_suffix}.jsonl", "w") do |io|
      res = Net::HTTP.get_response(URI(url))
      io.write(res.body) if res.is_a?(Net::HTTPSuccess)
    end
  end
end
