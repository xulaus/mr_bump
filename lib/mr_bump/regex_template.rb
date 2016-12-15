# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module MrBump
  class RegexTemplate < Mustache
    def render(data = template, ctx = {}, opts = '')
      Regexp.new(super(data, ctx), opts)
    end

    class Template < Mustache::Template
      def compile(src = @source)
        Generator.new.compile(tokens(src))
      end
    end

    def self.templateify(obj, _options = {})
      obj.is_a?(Template) ? obj : Template.new(obj)
    end

    class Generator < Mustache::Generator
      def str(s)
        Regexp.escape(super)
      end

      def ev(s)
        "' + (#{s}) + '"
      end
      def compile(exp)
        "'#{compile!(exp)}'"
      end

      def make_group(names, regex)
        return regex if names.empty?
        "(?<#{names.join('.')}>#{regex})"
      end

      def on_etag(name, _offset)
        make_group(name[2], ev(compile!(name).to_s))
      end

      def on_utag(name, _offset)
        make_group(name[2], ev(compile!(name).to_s))
      end

      def on_section(name, _offset, content, _raw, _delims)
        one_repeat = ev("v = #{compile!(name)}; ctx.push(v); r = '#{compile!(content)}'; ctx.pop; r;")
        make_group(name[2], "(#{one_repeat})*")
      end

      def on_inverted_section(name, _offset, content, _raw, _delims)
        one_repeat = ev("v = #{compile!(name)}; ctx.push(v); r = '#{compile!(content)}'; ctx.pop; r;")
        make_group( name[2], "(#{one_repeat})?")
      end
    end
  end
end
