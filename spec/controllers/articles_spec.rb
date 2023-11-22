require 'rails_helper'

describe 'News API', type: :request do
  describe 'POST /articles' do
    let(:article_params) do
      {
        title: 'New photography exhibition',
        content: 'In a new exhibition at the Royal Botanic Garden Edinburgh, famous photographer explores the astonishing diversity of nature.',
        author: 'Oscar Davies',
        category: 'Nature',
        published_at: '2020-02-10',
      }
    end

    context 'when parameters are valid' do
      before do
        post '/articles', params: article_params
      end

      it 'returns status code 201' do
        expect(response.status).to eq(201)
      end

      it 'adds an article to the database' do
        get '/articles'
        fail('Cannot access GET /articles') unless response.status == 200

        expected = [
          {
            id: 1,
            title: 'New photography exhibition',
            content: 'In a new exhibition at the Royal Botanic Garden Edinburgh, famous photographer explores the astonishing diversity of nature.',
            author: 'Oscar Davies',
            category: 'Nature',
            published_at: '2020-02-10',
          }.stringify_keys
        ]

        expect(JSON.parse(response.body)).to eq(expected)
      end

      it 'returns JSON of a created article' do
        expected = {
          id: 1,
          title: 'New photography exhibition',
          content: 'In a new exhibition at the Royal Botanic Garden Edinburgh, famous photographer explores the astonishing diversity of nature.',
          author: 'Oscar Davies',
          category: 'Nature',
          published_at: '2020-02-10',
        }.stringify_keys

        expect(JSON.parse(response.body)).to eq(expected)
      end
    end

    context 'when title is missing' do
      let(:invalid_params) do
        article_params.merge(title: nil)
      end

      before do
        post '/articles', params: invalid_params
      end

      it 'returns status code 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'when title is longer than 40 characters' do
      let(:invalid_params) do
        article_params.merge(title: 'New exhibition at the Royal Botanic Garden Edinburgh')
      end

      before do
        post '/articles', params: invalid_params
      end

      it 'returns status code 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'when content is missing' do
      let(:invalid_params) do
        article_params.merge(content: nil)
      end

      before do
        post '/articles', params: invalid_params
      end

      it 'returns status code 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'when author is missing' do
      let(:invalid_params) do
        article_params.merge(author: nil)
      end

      before do
        post '/articles', params: invalid_params
      end

      it 'returns status code 422' do
        expect(response.status).to eq(422)
      end
    end

    context 'when published_at is missing' do
      let(:invalid_params) do
        article_params.merge(published_at: nil)
      end

      before do
        post '/articles', params: invalid_params
      end

      it 'returns status code 422' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET /articles/:id' do
    context 'when article by given ID exists' do
      let(:article_params) do
        {
          title: 'New photography exhibition',
          content: 'In a new exhibition at the Royal Botanic Garden Edinburgh, famous photographer explores the astonishing diversity of nature.',
          author: 'Oscar Davies',
          category: 'Nature',
          published_at: '2020-02-10',
        }
      end

      let(:article) do
        post '/articles', params: article_params
        fail('Cannot create an article') unless response.status == 201
        JSON.parse(response.body)
      end

      before do
        get "/articles/#{article['id']}"
      end

      it 'returns 200 status code' do
        expect(response.status).to eq(200)
      end

      it 'returns JSON of a corresponding article' do
        expected = {
          id: article['id'],
          title: 'New photography exhibition',
          content: 'In a new exhibition at the Royal Botanic Garden Edinburgh, famous photographer explores the astonishing diversity of nature.',
          author: 'Oscar Davies',
          category: 'Nature',
          published_at: '2020-02-10',
        }.stringify_keys

        expect(JSON.parse(response.body)).to eq(expected)
      end
    end

    context 'when article by given ID does not exist' do
      before do
        get '/articles/999'
      end

      it 'returns 404 status code' do
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'GET /articles' do
    it 'returns status 200' do
      get '/articles'
      expect(response.status).to eq(200)
    end

    context 'when there are articles in the system' do
      let(:article_params) do
        [{
          title: 'New photography exhibition',
          content: 'In a new exhibition at the Royal Botanic Garden Edinburgh, famous photographer explores the astonishing diversity of nature.',
          author: 'Oscar Davies',
          category: 'Nature',
          published_at: '2020-02-10',
        },{
          title: "You can't reason about big balls of mud.",
          content: "Cathedral systems have clear properties you can reason about. These properties allow you to reason about them abstractly. Enable you to layer on new properties. Yet, there are few large cathedral systems in the wild. They're particularly rare in young companies experiencing rapid growth. That ecosystem's apex pattern is the big ball of mud... Big balls of mud appear to have properties, but they don't... Often the first phase of modifying a system is to establish a nuanced mental model of the system.",
          author: 'Will Larson',
          category: 'Software',
          published_at: '2018-05-23',
        },{
          title: 'Sakura Park Reconstruction',
          content: 'The work will include installing a new fountain and resetting the existing granite walls.',
          author: 'Edward Evans',
          category: 'Nature',
          published_at: '2020-02-11',
        }]
      end

      before do
        article_params.each do |params|
          post '/articles', params: params
          fail('Cannot create an article') unless response.status == 201
        end
      end

      it 'returns articles collection ordered by published_at descending' do
        get '/articles'

        expected = article_params.map.with_index(1) do |params, index|
          params['id'] = index
          params.stringify_keys
        end.sort do |a, b|
          Date.parse(b['published_at']) <=> Date.parse(a['published_at'])
        end

        expect(JSON.parse(response.body)).to eq(expected)
      end
    end

    context 'when there are no articles in the system' do
      it 'returns empty array JSON' do
        get '/articles'
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe 'DELETE /articles/:id' do
    let(:article) do
      post '/articles', params: {
        title: 'Sakura Park Reconstruction',
        content: 'The work will include installing a new fountain and resetting the existing granite walls.',
        author: 'Edward Evans',
        category: 'Nature',
        published_at: '2020-02-11',
      }
      fail('Cannot create an article') unless response.status == 201

      JSON.parse(response.body)
    end

    before do
      delete "/articles/#{article['id']}"
    end

    it 'returns status 405' do
      expect(response.status).to eq(405)
    end
  end

  describe 'PATCH /articles/:id' do
    let(:article) do
      post '/articles', params: {
        title: 'Sakura Park Reconstruction',
        content: 'The work will include installing a new fountain and resetting the existing granite walls.',
        author: 'Edward Evans',
        category: 'Nature',
        published_at: '2020-02-11',
      }
      fail('Cannot create an article') unless response.status == 201
      
      JSON.parse(response.body)
    end

    before do
      patch "/articles/#{article['id']}"
    end

    it 'returns status 405' do
      expect(response.status).to eq(405)
    end
  end

  describe 'PUT /articles/:id' do
    let(:article) do
      post '/articles', params: {
        title: 'Sakura Park Reconstruction',
        content: 'The work will include installing a new fountain and resetting the existing granite walls.',
        author: 'Edward Evans',
        category: 'Nature',
        published_at: '2020-02-11',
      }
      fail('Cannot create an article') unless response.status == 201
      
      JSON.parse(response.body)
    end

    before do
      put "/articles/#{article['id']}"
    end

    it 'returns status 405' do
      expect(response.status).to eq(405)
    end
  end
end
