RSpec::Matchers.define :have_md_field do |expected, with: nil|
  match do |actual|
    milkdown_editor = actual.find('[data-controller="milkdown-editor"] label', text: expected).find(:xpath, '..')

    # TODO: Wie gehe ich damit um, dass der Milkdown-Editor immer ein \n ans ende schreibt?
    # - Im Controller Sanitizen?
    # - Am Model Sanitizen mit einem Trait? DoesMarkdown[:question, :answer]
    if with.present?
      # milkdown adds linebreaks at the end, on input
      normalized_with = /\A\s*#{Regexp.escape(with.strip)}\s*\z/
      expect(milkdown_editor)
        .to have_field(expected, visible: false, with: normalized_with)
        .and have_css('.milkdown')
    else
      expect(milkdown_editor)
        .to have_field(expected, visible: false)
        .and have_css('.milkdown')
    end
  end
end

RSpec::Matchers.define :have_no_md_field do |expected|
  match do |actual|
    expect(actual).to_not have_css('[data-controller="milkdown-editor"] label', text: expected)
  end
end
