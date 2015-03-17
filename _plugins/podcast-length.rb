module Jekyllpodcasts
  class PodcastLength < Jekyll::Generator
    def generate(site)
      fsdir = '/home/podcasts/html'
      dir = site.config['baseurl']
      site.data['podcasts'].each do |name, podcast|
        podcast['entries'].each do |entry|
          location = fsdir + dir + podcast['baseurl'] + entry['url']
          entry['length'] = File.size(location)
        end
      end
    end
  end
end
