require 'rack'
require 'Xanthus'

describe Xanthus::Session do
  let(:req) { Rack::Request.new({ 'rack.input' => {} }) }
  let(:res) { Rack::Response.new([], '200', {}) }
  let(:cook) { {'_xanthus_app' => { 'xyz' => 'abc' }.to_json} }

  it 'deserializes json cookie if one exists' do
    req.cookies.merge!(cook)
    session = Session.new(req)
    expect(session['xyz']).to eq('abc')
  end

  describe '#store_session' do
    context 'without cookies in request' do
      before(:each) do
        session = Session.new(req)
        session['first_key'] = 'first_val'
        session.store_session(res)
      end

      it 'adds new cookie with \'_xanthus_app\' name to response' do
        cookie_str = res.headers['Set-Cookie']
        cookie = Rack::Utils.parse_query(cookie_str)
        expect(cookie['_xanthus_app']).not_to be_nil
      end

      it 'stores the cookie in json format' do
        cookie_str = res.headers['Set-Cookie']
        cookie = Rack::Utils.parse_query(cookie_str)
        cookie_val = cookie['_xanthus_app']
        cookie_hash = JSON.parse(cookie_val)
        expect(cookie_hash).to be_instance_of(Hash)
      end
    end

    context 'with cookies in request' do
      before(:each) do
        cook = {'_xanthus_app' => { 'pho' => 'soup' }.to_json }
        req.cookies.merge!(cook)
      end

      it 'reads the pre-existing cookie data into hash' do
        session = Session.new(req)
        expect(session['pho']).to eq('soup')
      end

      it 'saves new and old data to the cookie' do
        session = Session.new(req)
        session['machine'] = 'mocha'
        session.store_session(res)
        cookie_str = res['Set-Cookie']
        cookie = Rack::Utils.parse_query(cookie_str)
        cookie_val = cookie['_xanthus_app']
        cookie_hash = JSON.parse(cookie_val)
        expect(cookie_hash['pho']).to eq('soup')
        expect(cookie_hash['machine']).to eq('mocha')
      end
    end
  end
end
