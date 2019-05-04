require 'rails_helper'

describe '口コミ投稿機能', type: :system do
  
  let(:user) { FactoryBot.create(:user) }
  
  describe '新規作成機能' do
    it '口コミ投稿できる場合' do
      sign_in_as user
      product = FactoryBot.create(:product)
      visit product_path(product)
      expect{
        fill_in 'タイトル', with: 'テストタイトル'
        fill_in '口コミ内容', with: 'テストコンテント'
        click_on '投稿する'
      }.to change{ Post.count }.by(+1)
      expect(page).to have_content '口コミを投稿しました' #アイテム詳細ページの口コミ
    end
  end
  
  describe '一覧表示機能' do
    before do
      sign_in_as user
      product = FactoryBot.create(:product)
      visit product_path(product)
      fill_in 'タイトル', with: 'テストタイトル'
      fill_in '口コミ内容', with: 'テストコンテント'
      click_on '投稿する'
    end
    
    it '一覧表示に表示される' do
      visit posts_path
      expect(page).to have_content 'テストタイトル' #トップページの口コミ
    end
    
    it 'トップページに表示される' do
      visit root_path
      expect(page).to have_content 'テストタイトル' #トップページの口コミ
    end
    
    it 'ユーザー詳細ページに表示される' do
      visit user_path(user)
      expect(page).to have_content 'テストタイトル' #ユーザープロフィールの口コミ
    end
    
  end
    
  describe '削除機能' do  
    before do
      sign_in_as user
      product = FactoryBot.create(:product)
      visit product_path(product)
      fill_in 'タイトル', with: 'テストタイトル'
      fill_in '口コミ内容', with: 'テストコンテント'
      click_on '投稿する'
    end
    
    it '口コミを削除できること' do
      visit user_path(user)
      expect{click_on '口コミを削除'}.to change{ Post.count}. by(-1)
      expect(page).to have_content '口コミを削除しました'
    end
  end
  
  describe '編集機能' do
    before do
      sign_in_as user
      product = FactoryBot.create(:product)
      visit product_path(product)
      fill_in 'タイトル', with: 'テストタイトル'
      fill_in '口コミ内容', with: 'テストコンテント'
      click_on '投稿する'
    end

    it '口コミを編集できること' do
      visit user_path(user)
      click_on '口コミを編集'
      fill_in 'タイトル', with: 'アップデートタイトル'
      click_on '投稿する'
      expect(page).to have_content '口コミを更新しました'
      expect(page).to have_content 'アップデートタイトル'
    end
  end
end