# The plugins are not loaded by default
require "rouge/plugins/redcarpet"

module MarkdownHelper
  class RougeHTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  def markdown(text)
    extensions = { highlight: true, fenced_code_blocks: true }

    Redcarpet::Markdown.new(rouge_html_renderer, extensions).render(text).html_safe
  end


  # Rouge adds classes to code fragments for syntax highlighting
  # See app/javascript/stylesheets/highlight_themes/ for themes
  def rouge_html_renderer
    render_options = { hard_wrap: true }

    RougeHTML.new(render_options)
  end

end
