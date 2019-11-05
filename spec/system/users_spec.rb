require 'rails_helper'
require 'support/login_macros'

RSpec.describe User, type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before do
        visit new_user_path
      end
      context 'フォームの入力値が正常' do
        before do
          fill_in 'user_email', with: 'shin@example.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成ができる' do
          expect(current_path).to eq login_path
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力' do
        before do
          fill_in 'user_email', with: ''
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成が失敗する' do
          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済メールアドレスを使用' do
        let(:user){ create :user }
        before do
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成が失敗する' do
          expect(current_path).to eq users_path
          expect(page).to have_content 'Email has already been taken'
        end
      end
    end

    # describe 'マイページ' do
    #   context 'ログインしていない状態' do
    #     it "マイページへのアクセスが失敗する" do
    #       visit user_path
    #       expect(response).to redirect_to login_path
    #       expect(page).to have_content 'Login required'
    #     end
    #   end
    # end
  end

  describe 'ログイン後' do
    let(:user){ create :user }
    describe 'ユーザー編集' do
      before do
        login(user)
        visit edit_user_path(user)
      end
      context 'フォームの入力値が正常' do
        before do
          fill_in 'user_email', with: 'shin@example.com'
          fill_in 'user_password', with: 'password2'
          fill_in 'user_password_confirmation', with: 'password2'
          click_button 'Update'
        end
        it 'ユーザーの編集ができる' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'User was successfully updated.'
        end
      end
      context 'メールアドレスが未入力時に' do
        before do
          fill_in 'user_email', with: ''
          fill_in 'user_password', with: 'password2'
          fill_in 'user_password_confirmation', with: 'password2'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済メールアドレスを使用' do
        let(:user2){ create :user}
        before do
          fill_in 'user_email', with: user2.email
          fill_in 'user_password', with: 'password2'
          fill_in 'user_password_confirmation', with: 'password2'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'Email has already been taken'
        end
      end
    end
    # describe 'マイページ' do
    #   context 'ログインしていない状態' do
    #     it "マイページへのアクセスが失敗する" do
    #       visit user_path(user)
    #       expect(page).to eq login_path
    #       expect(page).to have_content 'Login required'
    #     end
    #   end
    # end
  end

  describe 'マイページ' do
    context 'タスクを作成' do
      before do
        let(:user){ create :user }
        let(:task){ create :task }
        login(user)
        visit new_task_path
      end
      it '新規作成したタスクが表示される' do

      end
    end
  end
end