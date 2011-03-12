require 'meta_where/constants'
require 'meta_where/predicate_methods'

module MetaWhere
  module Configuration

    def configure
      yield self
    end

    def load_core_extensions!
      require 'core_ext'
    end

    def setup_default_aliases!
      Constants::PREDICATE_ALIASES.each do |original, aliases|
        aliases.each do |aliaz|
          alias_predicate aliaz, original
        end
      end
    end

    def alias_predicate(new_name, existing_name)
      raise ArgumentError, 'the existing name should be the base name, not an _any/_all variation' if existing_name.to_s =~ /(_any|_all)$/
      ['', '_any', '_all'].each do |suffix|
        PredicateMethods.class_eval "alias :#{new_name}#{suffix} :#{existing_name}#{suffix} unless defined?(#{new_name}#{suffix})"
      end
    end

  end
end