require 'rest_client'

module Jekyllpodcasts
  class PodcastFeed < Jekyll::Page
    def initialize(site, base, dir, name, podcast)
      @site = site
      @base = base
      @dir = dir
      @name = name + '.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'feed.xml')

      # Prepare podcast data
      prepare_data(name, podcast)

      self.data['podcast'] = podcast
      self.data['short_name'] = name
    end

    def prepare_data(name, podcast)
      for entry in podcast['entries']
        entry['full_url'] = File.join(@site.config['file_base_url'], name, URI.escape(entry['url']))
        entry['length'] = RestClient.head(entry['full_url']).headers[:content_length]
      end
    end
  end

  class Generator < Jekyll::Generator
    def generate(site)
      # Set dir so we save at the top level.
      dir = ''
      site.data['podcasts'].each do |name, podcast|
        site.pages << PodcastFeed.new(site, site.source, dir, name, podcast)
      end
    end
  end
end
