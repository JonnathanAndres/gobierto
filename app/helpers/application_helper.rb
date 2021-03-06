module ApplicationHelper
  def render_if_exists(partial_path, partial_params = {}, format = "html.erb")
    partial_path_name = Pathname.new(partial_path)
    partial_file_name = "#{partial_path_name.dirname}/_#{partial_path_name.basename}.#{format}"

    render(partial_path, partial_params) if lookup_context.exists?(partial_file_name)
  end

  def load_module_sub_sections(module_name = nil)
    return unless module_name

    render_if_exists("#{module_name.underscore}/layouts/menu_subsections")
  end

  # Example: translate_enum_value(GobiertoParticipation::ProcessStage, :stage_type, :information)
  def translate_enum_value(object, enum_name, enum_value_name)
    I18n.t("activerecord.attributes.#{object.model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value_name}")
  end

  def localized_enum(class_name, enum_name)
    return {} unless class_name.respond_to?(enum_name.to_s.pluralize)

    class_name.send(enum_name.to_s.pluralize).reduce({}) do |enum_options, (key, _)|
      enum_options.merge!(
        { I18n.t("activerecord.attributes.#{class_name.model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{key}", default: key.capitalize) => key }
      )
    end
  end

  def privacy_policy_page_link
    if current_site && current_site.configuration.privacy_page?
      link_to t('layouts.accept_privacy_policy_signup'), current_site.configuration.privacy_page
    end
  end

  def tab_attributes(condition)
    {
      role:'tab', 'tabindex' => condition ? 0 : -1, 'aria-selected' => condition
    }
  end

  def show_social_links?
    !params[:controller].include?('user/')
  end

  def full_layout?
    !((controller_name == "contribution_containers") && (action_name == "show"))
  end

  def filetype_icon(attachment)
    extension = if attachment.class == String
                  attachment.split(".").last
                else
                  attachment.extension
                end

    fontawesome_filetype = if ::GobiertoAttachments::Attachment.extension_fontawesome_matching.has_key?(extension.to_sym)
                             "-" + ::GobiertoAttachments::Attachment.extension_fontawesome_matching[extension.to_sym]
                           else
                             ""
                           end
    html = "<i class='fa fa-file" + fontawesome_filetype + "-o'></i>"
    html.html_safe
  end
end
