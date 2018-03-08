require 'rack'
require 'xanthus'

describe Xanthus::ControllerBase do
  before(:all) do
    class TestsController < ControllerBase
      def index
        @tests = ['FOO', 'BAR']
        render(:index)
      end
    end
  end
  after(:all) { Object.send(:remove_const, 'TestsController') }

  let(:req) { Rack::Request.new({'rack.input' => {}}) }
  let(:res) { Rack::MockResponse.new('200',{},[]) }
  let(:tests_controller) { TestsController.new(req, res) }
  let(:tests_controller2) { TestsController.new(req, res) }

  describe '#render_content' do
    before(:each) do
      tests_controller.render_content 'Hello, Xanthus', 'text/html'
    end

    it 'sets the response content type' do
      expect(res['Content-Type']).to eq('text/html')
    end

    it 'sets the response body' do
      expect(res.body).to eq('Hello, Xanthus')
    end

    describe '#already_rendered?' do
      let(:tests_controller2) { TestsController.new(req, res) }

      it 'is false before rendering' do
        expect(tests_controller2.already_rendered?).to be_falsey
      end

      it 'is true after rendering content' do
        tests_controller2.render_content 'Hello, Xanthus', 'text/html'
        expect(tests_controller2.already_rendered?).to be_truthy
      end

      it 'raises an error when attempting to render twice' do
        tests_controller2.render_content 'Hello, Xanthus', 'text/html'
        expect do
          tests_controller2.render_content 'Hello, Xanthus', 'text/html'
        end.to raise_error(AlreadyRenderedError)
      end
    end
  end

  describe '#redirect' do
    before(:each) do
      tests_controller.redirect_to('http://www.google.com')
    end

    it 'sets the header' do
      expect(tests_controller.res.header['location']).to eq('http://www.google.com')
    end

    it 'sets the status' do
      expect(tests_controller.res.status).to eq(302)
    end

    describe '#already_rendered?' do

      it 'is false before rendering' do
        expect(tests_controller2.already_rendered?).to be_falsey
      end

      it 'is true after rendering content' do
        tests_controller2.redirect_to('http://google.com')
        expect(tests_controller2.already_rendered?).to be_truthy
      end

      it 'raises an error when attempting to render twice' do
        tests_controller2.redirect_to('http://google.com')
        expect do
          tests_controller2.redirect_to('http://google.com')
        end.to raise_error(AlreadyRenderedError)
      end
    end
  end


describe '#render' do
  before(:each) do
    tests_controller.index
  end

  let(:tests_controller) { TestsController.new(req, res) }
  it 'renders the html of the index view' do
    expect(tests_controller.res.body).to include('Hello, Xanthus!')
    expect(tests_controller.res.body).to include('<h1>')
    expect(tests_controller.res['Content-Type']).to eq('text/html')
  end

  it 'shows the proper instance variables in the index view' do
    expect(tests_controller.res.body).to include('BAR')
    expect(tests_controller.res.body).to include('FOO')
    expect(tests_controller.res['Content-Type']).to eq('text/html')
  end

  describe '#already_rendered?' do
    let(:tests_controller2) { TestsController.new(req, res) }
    it 'is false before rendering' do
      expect(tests_controller2.already_rendered?).to be_falsey
    end

    it 'is true after rendering content' do
      tests_controller2.index
      expect(tests_controller2.already_rendered?).to be_truthy
    end

    it 'raises an error when attempting to render twice' do
      tests_controller2.index
      expect do
        tests_controller2.index
      end.to raise_error(AlreadyRenderedError)
    end
  end
end

describe '#session' do
  it 'returns a session instance' do
    expect(tests_controller.session).to be_a(Session)
  end

  it 'returns the same instance on successive invocations' do
    first_result = tests_controller.session
    expect(tests_controller.session).to be(first_result)
  end
end

shared_examples_for 'storing session data' do
  it 'should store the session data' do
    tests_controller.session['test_key'] = 'test_value'
    tests_controller.send(method, *args)
    cookie_str = res['Set-Cookie']
    cookie = Rack::Utils.parse_query(cookie_str)
    cookie_val = cookie['_xanthus_app']
    cookie_hash = JSON.parse(cookie_val)
    expect(cookie_hash['test_key']).to eq('test_value')
  end
end

describe '#render_content' do
  let(:method) { :render_content }
  let(:args) { ['test', 'text/plain'] }
  include_examples 'storing session data'
end

describe '#redirect_to' do
  let(:method) { :redirect_to }
  let(:args) { ['http://appacademy.io'] }
  include_examples 'storing session data'
end
end
