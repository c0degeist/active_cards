require 'rails_helper'

RSpec.describe MarkdownHelper, type: :helper do

  describe '#markdown' do
    it 'converts markdown to html' do
      output = helper.markdown('# Titel')
      expect(output).to include '<h1>Titel</h1>'
    end

    it 'adds classes to code fragments for syntax highlighting' do
      markdown = <<~MARKDOWN
        ```ruby
          puts "hello world"
        ```
      MARKDOWN

      output = helper.markdown(markdown)
      expect(output).to include '<div class="highlight">'
      expect(output).to include '<pre class="highlight ruby"><code>'
      expect(output).to include '<span class="nb">puts</span>'
      expect(output).to include '<span class="s2">"hello world"</span>'
    end
  end
end
