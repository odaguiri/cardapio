require_relative './test_helper'

module MenuService
describe 'Menu Integration' do
  include Minitest::Hooks
  include Rack::Test::Methods

  def app; App end

  def valid_attributes
    { title: 'Title A', description: 'Description A' }
  end

  describe 'GET /menus' do
    before do
      @menu = Menu.create(valid_attributes).values
      get '/menus'
    end

    it 'returns a list' do
      _(last_response.body).must_equal [@menu].to_json
    end
  end

  describe 'POST /menus' do
    before { post '/menus', valid_attributes }

    it 'creates a menu' do
      json = JSON.parse(last_response.body)
      _(json['title']).must_equal 'Title A'
      _(json['description']).must_equal 'Description A'
    end
  end

  describe 'PUT /menus/:id' do
    subject { Menu.create(valid_attributes) }

    before do
      put "/menus/#{subject.id}", { title: 'Title Updated', description: 'Description Updated'}
    end

    it 'updates a menu by id' do
      json = JSON.parse(last_response.body)
      _(json['title']).must_equal 'Title Updated'
      _(json['description']).must_equal 'Description Updated'
    end
  end

  describe 'DELETE /menus/:id' do
    subject { Menu.create(valid_attributes) }

    before { delete "/menus/#{subject.id}" }

    it 'deletes a menu by id' do
      _(MenuService::Menu.first(id: subject.id)).must_be_nil
    end
  end
end
end