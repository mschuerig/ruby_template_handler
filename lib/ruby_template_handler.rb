
require 'action_view'

class RubyTemplateHandler < ActionView::TemplateHandler
  VERSION = '0.0.2'
  include ActionView::TemplateHandlers::Compilable

  def compile(template)
    src = template.source
    unless File.basename(template.filename).starts_with?('_')
      src = 'ActiveSupport::JSON.encode(' + src + ')'
    end
    'self.output_buffer = (' + src + ')'
  end
end
