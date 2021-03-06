module Qiita
  module Markdown
    module Transformers
      class FilterIframe
        URL_WHITE_LIST = [
        ].flatten.freeze

        HOST_WHITE_LIST = [
          Embed::Youtube::SCRIPT_HOSTS,
          Embed::SlideShare::SCRIPT_HOST,
          Embed::GoogleSlide::SCRIPT_HOST,
        ].flatten.freeze

        def self.call(*args)
          new(*args).transform
        end

        def initialize(env)
          @env = env
        end

        def transform
          if name == "iframe"
            if URL_WHITE_LIST.include?(node["src"]) || HOST_WHITE_LIST.include?(host_of(node["src"]))
              node.children.unlink
            else
              node.unlink
            end
          end
        end

        private

        def name
          @env[:node_name]
        end

        def node
          @env[:node]
        end

        def host_of(url)
          Addressable::URI.parse(url).host if url
        rescue Addressable::URI::InvalidURIError
          nil
        end
      end
    end
  end
end
