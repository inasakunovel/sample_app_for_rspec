require 'rails_helper'
require 'support/login_macros'

RSpec.describe User, type: :system do
  let(:user){ create :user }
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before do
        visit new_user_path
      end
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成ができる' do
          fill_in 'user_email', with: 'shin@example.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
          expect(page).to have_content 'User was successfully created.'
          expect(current_path).to eq login_path
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'user_email', with: ''
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq users_path
        end
      end
      context '登録済メールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
          expect(page).to have_content 'Email has already been taken'
          expect(current_path).to eq users_path
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it "マイページへのアクセスが失敗する" do
          visit user_path(user)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集ができる' do
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: 'shin@example.com'
          fill_in 'user_password', with: 'password_after'
          fill_in 'user_password_confirmation', with: 'password_after'
          click_button 'Update'
          expect(page).to have_content 'User was successfully updated.'
          expect(current_path).to eq user_path(user)
        end
      end
      context 'メールアドレスが未入力時に' do
        it 'ユーザーの編集が失敗する' do
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: ''
          fill_in 'user_password', with: 'password_after'
          fill_in 'user_password_confirmation', with: 'password_after'
          click_button 'Update'
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq user_path(user)
        end
      end
      context '登録済メールアドレスを使用' do
        it 'ユーザーの編集が失敗' do
          user_duplicate = create :user
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: user_duplicate.email
          fill_in 'user_password', with: 'password_after'
          fill_in 'user_password_confirmation', with: 'password_after'
          click_button 'Update'
          expect(page).to have_content 'Email has already been taken'
          expect(current_path).to eq user_path(user)
        end
      end
      context '他ユーザーのユーザー編集ページにアクセス' do
        # let!(:user2){ create :user}
        fit 'アクセスが失敗する' do
          another_user = create :user
          login(user)
          visit edit_user_path(another_user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(user)
        end
      end
      context '他ユーザーのタスク編集ページにアクセス' do
        it 'アクセスが失敗する' do
          another_user = create :user
          create(:task, user_id: user.id )
          login(user)
          visit edit_user_path(another_user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(user)
        end
      end
    end
  end

  describe 'マイページ' do
    context 'マイページに移動時' do
      it 'ユーザーのタスクが表示される' do
        task = create(:task, user_id: user.id )
        login(user)
        visit tasks_path
        click_link 'Mypage'
        expect(page).to have_content(task.title)
        expect(current_path).to eq user_path(user)
      end
    end
  end
end