module Jekyllpodcasts
  class PodcastLength < Jekyll::Generator
    def generate(site)
      fsdir = '/usr/share/nginx/html/podcasts/files/'
      site.data['podcasts'].each do |name, podcast|
        podcast['entries'].each do |entry|
          location = File.join(fsdir, podcast['baseurl'], entry['url'])
          entry['length'] = File.size(location)
        end
      end
    end
  end
end
