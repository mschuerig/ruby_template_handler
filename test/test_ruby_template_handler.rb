require File.dirname(__FILE__) + '/test_helper.rb'
require 'ostruct'
require 'action_controller'

ActionView::Template.register_template_handler :rb, RubyTemplateHandler

class Movie
  def self.primary_key
    'id'
  end
end

class TestRubyTemplateHandler < Test::Unit::TestCase

  class TestController < ActionController::Base
    def initialize(movies)
      @movies = Array(movies)
      @count = @movies.size
    end
    undef_method :request, :response
  end
  
  class TestTemplate < ActionView::Template
    def initialize(filename, source)
      @filename, @source = filename, source
      self.format = 'json'
      self.extension = 'rb'
    end
    def source
      @source
    end
  end
  
  def setup
    @movie = OpenStruct.new({
      :title => 'Rendered Insane',
      :release_date => Time.utc(2008, 4, 2)
    })
    
    controller = TestController.new(@movie)
    @view = ActionView::Base.new
    @view.controller = controller
    
    @template = TestTemplate.new('app/views/movies/index.json.rb', <<TMPL
{
  :identifier => Movie.primary_key,
  :totalCount => @count
}
TMPL
    )

    @partial = TestTemplate.new('app/views/movies/_movie.json.rb', <<TMPL
{
  :title => movie.title,
  :releaseDate => movie.release_date
}
TMPL
    )
  end
  
  def test_render_template
    result = @template.render(@view)
    assert_kind_of String, result
    assert_match /"identifier": "id"/, result
    assert_match /"totalCount": 1/, result
  end
  
  def test_render_partial
    result = @partial.render(@view, :movie => @movie)
    assert_kind_of Hash, result
    assert_equal(
      {
        :title => 'Rendered Insane',
        :releaseDate => Time.utc(2008, 4, 2)
      }, result)
  end
end
