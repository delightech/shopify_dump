# frozen_string_literal: true

require 'shopify_api'
require 'logger'
require 'open3'

class ShopifyDump::Dumper
  API_KEY = ENV['API_KEY']
  PASSWORD = ENV['PASSWORD']
  SHOP_NAME = ENV['SHOP_NAME']
  API_VERSION = ENV['API_VERSION']

  def initialize
    ShopifyAPI::Base.site = "https://#{API_KEY}:#{PASSWORD}@#{SHOP_NAME}.myshopify.com"
    ShopifyAPI::Base.api_version = API_VERSION
    @client = ShopifyAPI::GraphQL.client
    @logger = Logger.new(STDOUT)
  end

  def dump
    # start bulk operation
    start_bulk_operation
    # download jsonl file
    download_jsonl(fetch_download_url)
  end

  private

  def start_bulk_operation
    @client.query(
      @client.parse <<~'GRAPHQL'
        mutation {
          bulkOperationRunQuery(
            query:"""
            {
              productVariants(query: "created_at:>=2021-01-01 AND created_at:<2021-04-01") {
                edges {
                  node {
                    id
                    availableForSale
                    barcode
                    compareAtPrice
                    createdAt
                    displayName
                    inventoryQuantity
                    price
                    sku
                    taxable
                    title
                    updatedAt
                    title
                    product {
                      id
                      title
                    }
                  }
                }
              }
            }
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
      if result.to_h['data']['currentBulkOperation']['status'] == 'COMPLETED'
        return result.to_h['data']['currentBulkOperation']['url']
      elsif result.to_h['data']['currentBulkOperation']['status'] == 'RUNNING'
        i += 10
        sleep(i)
      else
        @logger.info("Bulk operation not running. status:#{result.to_h['data']['currentBulkOperation']['status']}")
        break
      end
    end
  end

  def current_bulk_operation
    @client.query(
      @client.parse <<-'GRAPHQL'
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

  def download_jsonl(req_url)
    out, err, status = Open3.capture3("curl '#{req_url}' -o product_variants.jsonl")
    @logger.info(out)
    @logger.info(err)
    @logger.error('Error occur') if status != 0
  end
end
