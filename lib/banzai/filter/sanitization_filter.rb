require 'html/pipeline/filter'
require 'html/pipeline/sanitization_filter'

module Banzai
  module Filter
    # Sanitize HTML
    #
    # Extends HTML::Pipeline::SanitizationFilter with a custom whitelist.
    class SanitizationFilter < HTML::Pipeline::SanitizationFilter
      def whitelist
        whitelist = super

        customize_whitelist(whitelist)

        whitelist
      end

      private

      def customized?(transformers)
        transformers.last.source_location[0] == __FILE__
      end

      def customize_whitelist(whitelist)
        # Only push these customizations once
        return if customized?(whitelist[:transformers])

        # Allow code highlighting
        whitelist[:attributes]['pre'] = %w(class)
        whitelist[:attributes]['span'] = %w(class)

        # Allow table alignment
        whitelist[:attributes]['th'] = %w(style)
        whitelist[:attributes]['td'] = %w(style)

        # Allow span elements
        whitelist[:elements].push('span')

        # Allow abbr elements with title attribute
        whitelist[:elements].push('abbr')
        whitelist[:attributes]['abbr'] = %w(title)

        # Allow any protocol in `a` elements...
        whitelist[:protocols].delete('a')

        # ...but then remove links with the `javascript` protocol
        whitelist[:transformers].push(remove_javascript_links)

        # Remove `rel` attribute from `a` elements
        whitelist[:transformers].push(remove_rel)

        # Remove `class` attribute from non-highlight spans
        whitelist[:transformers].push(clean_spans)

        whitelist
      end

      def remove_javascript_links
        lambda do |env|
          node = env[:node]

          return unless node.name == 'a'
          return unless node.has_attribute?('href')

          if node['href'].start_with?('javascript', ':javascript')
            node.remove_attribute('href')
          end
        end
      end

      def remove_rel
        lambda do |env|
          if env[:node_name] == 'a'
            env[:node].remove_attribute('rel')
          end
        end
      end

      def clean_spans
        lambda do |env|
          node = env[:node]

          return unless node.name == 'span'
          return unless node.has_attribute?('class')

          unless has_ancestor?(node, 'pre')
            node.remove_attribute('class')
          end

          { node_whitelist: [node] }
        end
      end
    end
  end
end