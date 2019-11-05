require 'rails_helper'

RSpec.describe 'UserSession', type: :system do
  let(:user){ create :user }
  before do
    visit login_path
  end
  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログインが成功する' do
        login(user)
        expect(current_path).to eq root_path
      end
    end
    context 'フォームが未入力' do
      before do
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        click_button "Login"
      end
      it 'ログインが失敗する' do
        expect(current_path).to_not eq root_path
      end
    end
  end
  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      before do
        fill_in 'Email', with: 'test@gamil.com'
        fill_in 'Password', with: '000000'
        click_button 'Login'
      end
      it 'ログアウト処理が成功する' do
        click_link 'Logout'
        expect(current_path).to eq root_path
      end
    end
  end
end