module Jekyllpodcasts
  class PodcastFeed < Jekyll::Page
    def initialize(site, base, dir, name, podcast)
      @site = site
      @base = base
      @dir = dir
      @name = name + '.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'feed.xml')
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
      end
    end
  end
end
