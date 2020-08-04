require 'rails_helper'

RSpec.describe '/posts/:id', type: :request do
  let(:post_params) { { content: 'content1' } }

  it '@@@「localhost:3000/posts/index」へのアクセス時にエラーが起きています。@@@' do
    get '/posts/index'
    expect(response).to have_http_status(200)
  end

  it '@@@「localhost:3000/posts/1」のようなURLに対応するルーティングがありません。@@@' do
    post = Post.create(post_params)
    expect { get "/posts/#{post.id}" }.not_to raise_error(ActionController::RoutingError)
  end

  it '@@@投稿詳細ページへのアクセス時にエラーが起きています。@@@' do
    post = Post.create(post_params)
    get "/posts/#{post.id}"
    expect(response).to have_http_status(200)
  end

  it '@@@投稿詳細ページに投稿の内容が表示されていません。@@@' do
    post = Post.create(post_params)
    get "/posts/#{post.id}"
    expect(response.body).to include(post.content)
  end

  it '@@@投稿詳細ページに投稿の作成時刻が表示されていません。@@@' do
    post = Post.create(post_params)
    get "/posts/#{post.id}"
    expect(response.body).to include(post.created_at.to_s)
  end

  it '@@@「localhost:3000/posts/index」で投稿詳細ページへのリンクが正しく設定されていません。@@@' do
    post = Post.create(post_params)
    get '/posts/index'
    expect(response.body).to match(%r{<a\s+href\s*=\s*"/posts/#{post.id}[?"]})
  end
end
