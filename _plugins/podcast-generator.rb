require 'rest_client'

module Jekyllpodcasts
  class PodcastFeed < Jekyll::Page
    def initialize(site, base, dir, name, podcast)
      @site = site
      @base = base
      @dir = dir
      @name = name + '.xml'
      @header_cache = site.data['cache']['headers'] || {}
      @write_cache = false

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'feed.xml')

      # Prepare podcast data
      prepare_data(name, podcast)

      if (@write_cache)
        write_cache()
      end

      self.data['podcast'] = podcast
      self.data['short_name'] = name
    end

    def prepare_data(name, podcast)
      for entry in podcast['entries']
        entry['full_url'] = File.join(@site.config['file_base_url'], name, URI.escape(entry['url']))
        entry['length'] = get_headers(entry['full_url'])['content_length']
      end
    end


    def get_headers(url)
      if not(@header_cache.has_key?(url))
        headers = RestClient.head(url).headers
        @header_cache[url] = headers.collect{|k,v| [k.to_s, v]}.to_h
        @write_cache = true
      end
      return @header_cache[url]
    end

    def write_cache()
      File.open('_data/cache/headers.yml', 'w') { |f|
        f.write @header_cache.to_yaml
      }
    end
  end

  class PodcastPage < Jekyll::Page
    def initialize(site, base, dir, name, podcast)
      @site = site
      @base = base
      @dir = dir
      @name = name + '.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'podcast.html')

      self.data['podcast'] = podcast
      self.data['short_name'] = name
    end
  end

  class Generator < Jekyll::Generator
    def generate(site)
      # Set dir so we save at the top level.
      dir = ''
      site.data['podcasts'].each do |name, podcast|
        site.pages << PodcastFeed.new(site, site.source, dir, name, podcast)
        site.pages << PodcastPage.new(site, site.source, dir, name, podcast)
      end
    end
  end
end
