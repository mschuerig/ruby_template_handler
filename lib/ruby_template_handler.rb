
require 'action_view'

class RubyTemplateHandler < ActionView::TemplateHandler
  VERSION = '0.0.1'
  include ActionView::TemplateHandlers::Compilable

  def compile(template)
    src =  'self.output_buffer = (' + template.source + ')'
    unless File.basename(template.filename).starts_with?('_')
      src += '.to_json'
    end
    src
  end
end
