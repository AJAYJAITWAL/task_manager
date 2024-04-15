namespace :elasticsearch do
  desc 'Import Elasticsearch models'
  task import_models: :environment do
    Elasticsearch::Model.client = Elasticsearch::Client.new(url: 'http://localhost:9200')

    klass = ENV['CLASS'].constantize
    klass.import(force: true)
  end
end
