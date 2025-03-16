module StateHelper

  def test_state_badge(state)
    color_class = case state.to_sym
    when :started
      "warning"
    when :finished
      "success"
    else
      raise "Unknown state"
    end

    content_tag(:span, state, class: "badge text-bg-#{color_class}")
  end

end
