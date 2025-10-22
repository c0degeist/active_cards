module MarkdownHelpers
  def fill_md_field(label, with: '')
    milkdown_container = find('label', text: label).find(:xpath, './ancestor::*[@data-controller="milkdown-editor"]')
    editable_content = milkdown_container.find('.milkdown [contenteditable="true"]')

    editable_content.click
    editable_content.set('')
    editable_content.send_keys(with)

    # wait for milkdown to sync values
    expect(milkdown_container).to have_field(label, visible: false, with: "#{with}\n") # milkdown adds \n at the end
  end
end

RSpec.configure do |c|
  c.include(MarkdownHelpers)
end
