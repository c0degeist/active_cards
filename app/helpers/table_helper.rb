module TableHelper

  def no_elements_found(text = "No elements found")
    content_tag(:p, text, class: "text-muted")
  end

end
