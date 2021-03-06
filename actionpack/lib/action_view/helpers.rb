require 'active_support/benchmarkable'

module ActionView #:nodoc:
  module Helpers #:nodoc:
    autoload :ActiveModelHelper, 'action_view/helpers/active_model_helper'
    autoload :AjaxHelperCompat, 'action_view/helpers/ajax_helper'
    autoload :AssetTagHelper, 'action_view/helpers/asset_tag_helper'
    autoload :AtomFeedHelper, 'action_view/helpers/atom_feed_helper'
    autoload :CacheHelper, 'action_view/helpers/cache_helper'
    autoload :CaptureHelper, 'action_view/helpers/capture_helper'
    autoload :DateHelper, 'action_view/helpers/date_helper'
    autoload :DebugHelper, 'action_view/helpers/debug_helper'
    autoload :FormHelper, 'action_view/helpers/form_helper'
    autoload :FormOptionsHelper, 'action_view/helpers/form_options_helper'
    autoload :FormTagHelper, 'action_view/helpers/form_tag_helper'
    autoload :JavaScriptHelper, 'action_view/helpers/javascript_helper'
    autoload :NumberHelper, 'action_view/helpers/number_helper'
    autoload :AjaxHelper, 'action_view/helpers/ajax_helper'
    autoload :RawOutputHelper, 'action_view/helpers/raw_output_helper'
    autoload :RecordIdentificationHelper, 'action_view/helpers/record_identification_helper'
    autoload :RecordTagHelper, 'action_view/helpers/record_tag_helper'
    autoload :SanitizeHelper, 'action_view/helpers/sanitize_helper'
    autoload :TagHelper, 'action_view/helpers/tag_helper'
    autoload :TextHelper, 'action_view/helpers/text_helper'
    autoload :TranslationHelper, 'action_view/helpers/translation_helper'
    autoload :UrlHelper, 'action_view/helpers/url_helper'

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      include SanitizeHelper::ClassMethods
    end

    include ActiveSupport::Benchmarkable

    include ActiveModelHelper
    include AssetTagHelper
    include AtomFeedHelper
    include CacheHelper
    include CaptureHelper
    include DateHelper
    include DebugHelper
    include FormHelper
    include FormOptionsHelper
    include FormTagHelper
    include JavaScriptHelper
    include NumberHelper
    include AjaxHelperCompat
    include RawOutputHelper
    include RecordIdentificationHelper
    include RecordTagHelper
    include SanitizeHelper
    include TagHelper
    include TextHelper
    include TranslationHelper
    include UrlHelper
  end
end
