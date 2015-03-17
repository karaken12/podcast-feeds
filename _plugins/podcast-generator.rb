module Jekyllpodcasts
  class PodcastFeed < Jekyll::Page
    def initialize(site, base, dir, podcast)
      @site = site
      @base = base
      @dir = dir
      @name = 'feed.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'feed.xml')
      self.data['podcast'] = podcast
    end
  end

  class Generator < Jekyll::Generator
    def generate(site)
      dir = site.config['baseurl']
#      site.data['podcasts'].each do |podcast_pair|
#        name = podcast_pair[0]
#        podcast = podcast_pair[1]
#        puts name
#        puts podcast
#        puts podcast['baseurl']
#        puts '---'
#      end
      site.data['podcasts'].each do |name, podcast|
        site.pages << PodcastFeed.new(site, site.source, File.join(dir, podcast['baseurl']), podcast)
      end
    end
  end
end
