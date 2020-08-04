require 'rails_helper'

RSpec.describe '/posts/:id/destroy', type: :request do
  let(:content_string) { 'test_content' }
  let(:post_instance) { Post.create(content: content_string) }

  it '@@@投稿詳細ページへのアクセス時にエラーが起きています。@@@' do
    get "/posts/#{post_instance.id}"
    expect(response).to have_http_status(200)
  end

  it '@@@投稿詳細ページに削除用のリンクがありません。@@@' do
    get "/posts/#{post_instance.id}"
    expect(response.body).to include('削除')
  end

  it '@@@投稿詳細ページで、削除用のリンクが正しく設定されていません。@@@' do
    get "/posts/#{post_instance.id}"
    expect(response.body).to match(%r{<a.*?href\s*=\s*"/posts/#{post_instance.id}/destroy[?"]})
  end

  it '@@@投稿詳細ページで、削除用のリンクのmethodがpostに設定されていません。@@@' do
    get "/posts/#{post_instance.id}"
    expect(response.body).to match(%r{<a.*?method\s*=\s*"post".*?href\s*=\s*"/posts/#{post_instance.id}/destroy[?"]})
  end

  it '@@@「localhost:3000/posts/1/destroy」のようなURLに対応するルーティングがありません。@@@' do
    expect { post "/posts/#{post_instance.id}/destroy" }.not_to raise_error(ActionController::RoutingError)
  end

  it '@@@投稿の削除時にエラーが発生しています。プレビューで確認してみましょう。@@@' do
    expect { post "/posts/#{post_instance.id}/destroy" }.not_to raise_error
  end

  it '@@@投稿の削除時にデータベースからデータが削除されていません。@@@' do
    post_instance
    expect { post "/posts/#{post_instance.id}/destroy" }.to change(Post, :count).by(-1)
  end

  it '@@@投稿の削除後に投稿一覧ページが表示されていません。@@@' do
    post "/posts/#{post_instance.id}/destroy"
    expect(response).to redirect_to(%r{/posts/index[?"]})
  end

  it '@@@投稿の削除後にフラッシュメッセージが設定されていません。@@@' do
    post "/posts/#{post_instance.id}/destroy"
    expect(flash[:notice]).to be_present
  end

  it '@@@投稿の削除後のフラッシュメッセージが間違っています。@@@' do
    post "/posts/#{post_instance.id}/destroy"
    expect(flash[:notice]).to eq('投稿を削除しました')
  end

  it '@@@投稿の削除後に、投稿一覧ページでフラッシュメッセージが表示されていません。@@@' do
    allow_any_instance_of(ApplicationController).to receive(:flash).and_return(notice: '投稿を削除しました')
    get '/posts/index'
    expect(response.body).to include('投稿を削除しました')
  end
end
