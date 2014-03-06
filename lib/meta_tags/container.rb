require "sanitize"

module MetaTags
  class Container
    attr_accessor :default_title,
                  :default_description,
                  :default_image,
                  :default_url,
                  :default_site_name,
                  :default_keywords,
                  :default_type,
                  :default_site,
                  :default_card,
                  :title_changed,
                  :description_changed,
                  :image_changed,
                  :url_changed,
                  :site_name_changed,
                  :keywords_changed,
                  :type_changed,
                  :site_changed,
                  :card_changed,

    TAGS_LIST = %w(
      title description image url site_name keywords type site card
    )

    TAGS_LIST.each do |label|
      class_eval <<-CLASS
        def #{ label }
          Sanitize.clean(@#{ label } || default_#{ label })
        end

        def #{ label }=(value)
          @#{ label }_changed = true
          @#{ label } = value
        end

        def #{ label }_changed?
          !!@#{ label }_changed
        end
      CLASS
    end

    def initialize options
      options.each do |label, value|
        self.send("default_#{ label }=", value)
      end
    end

    def title=(value)
      @title_changed = true
      if default_title == value || !MetaTags.keep_default_title_present
        @title = value
      elsif MetaTags.keep_default_title_present
        @title = "#{ value } - #{ default_title }"
      end
    end


    def reset_changed_status
      TAGS_LIST.each do |label|
        self.send("#{ label }_changed=", false)
      end
    end
  end
end