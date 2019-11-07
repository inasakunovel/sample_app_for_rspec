require 'rails_helper'
require 'support/login_macros'

RSpec.describe 'UserSession', type: :system do
  let(:user){ create :user }
  describe 'ログイン前' do
    before do
      visit login_path
    end
    context 'フォームの入力値が正常' do
      before do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: '000000'
        click_button "Login"
      end
      it 'ログインが成功する' do
        expect(page).to have_content 'Login successful'
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
        expect(page).to have_content 'Login failed'
        expect(current_path).to eq login_path
      end
    end
  end
  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        login(user)
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
        expect(current_path).to eq root_path
      end
    end
  end
end