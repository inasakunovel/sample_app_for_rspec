require 'rails_helper'

RSpec.describe 'UserSession', type: :system do
  describe 'ログイン前' do
    # context 'フォームの入力値が正常' do
    #   let(:user) { create(:user) }
    #   before do
    #     visit login_path
    #     fill_in 'Email', with: user.email
    #     fill_in 'Password', with: user.password
    #     click_button "Login"
    #   end
    #   it 'ログインが成功する' do
    #     expect(page).to have_content 'Login successful'
    #     expect(current_path).to eq root_path
    #   end
    # end
    # context 'フォームが未入力' do
    #   before do
    #     fill_in 'Email', with: ''
    #     fill_in 'Password', with: ''
    #     click_button "Login"
    #   end
    #   it 'ログインが失敗する' do
    #     expect(page).to have_content 'Login failed'
    #     expect(current_path).to eq login_path
    #   end
    # end
  end
  # describe 'ログイン後' do
  #   context 'ログアウトボタンをクリック' do
  #     before do
  #       fill_in 'Email', with: user.email
  #       fill_in 'Password', with: user.password
  #       click_button 'Login'
  #     end
  #     it 'ログアウト処理が成功する' do
  #       click_link 'Logout'
  #       expect(page).to have_content 'Logged out'
  #       expect(current_path).to eq root_path
  #     end
  #   end
  # end
end