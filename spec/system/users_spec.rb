require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user){ create :user }
  let(:another_user){ create :user }
  let(:task){ create(:task, user_id: user.id ) }
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
    before do
      login(user)
    end
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集ができる' do
          visit edit_user_path(user)
          fill_in 'user_email', with: 'shin@example.com'
          fill_in 'user_password', with: 'password_changed'
          fill_in 'user_password_confirmation', with: 'password_changed'
          click_button 'Update'
          expect(page).to have_content 'User was successfully updated.'
          expect(current_path).to eq user_path(user)
        end
      end
      context 'メールアドレスが未入力時に' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'user_email', with: ''
          fill_in 'user_password', with: 'password_changed'
          fill_in 'user_password_confirmation', with: 'password_changed'
          click_button 'Update'
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq user_path(user)
        end
      end
      context '登録済メールアドレスを使用' do
        it 'ユーザーの編集が失敗' do
          visit edit_user_path(user)
          fill_in 'user_email', with: another_user.email
          fill_in 'user_password', with: 'password_changed'
          fill_in 'user_password_confirmation', with: 'password_changed'
          click_button 'Update'
          expect(page).to have_content 'Email has already been taken'
          expect(current_path).to eq user_path(user)
        end
      end
      context '他ユーザーのユーザー編集ページにアクセス' do
        it 'アクセスが失敗する' do
          visit edit_user_path(another_user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(user)
        end
      end
      context '他ユーザーのタスク編集ページにアクセス' do
        it 'アクセスが失敗する' do
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
        task
        login(user)
        visit tasks_path
        click_link 'Mypage'
        expect(page).to have_content(task.title)
        expect(current_path).to eq user_path(user)
      end
    end
  end
end