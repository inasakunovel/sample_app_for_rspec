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
        before do
          fill_in 'user_email', with: 'shin@example.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成ができる' do
          expect(page).to have_content 'User was successfully created.'
          expect(current_path).to eq login_path
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
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq users_path
        end
      end
      context '登録済メールアドレスを使用' do
        before do
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成が失敗する' do
          expect(page).to have_content 'Email has already been taken'
          expect(current_path).to eq users_path
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        before do
          visit user_path(user)
        end
        it "マイページへのアクセスが失敗する" do
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        before do
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: 'shin@example.com'
          fill_in 'user_password', with: 'password2'
          fill_in 'user_password_confirmation', with: 'password2'
          click_button 'Update'
        end
        it 'ユーザーの編集ができる' do
          expect(page).to have_content 'User was successfully updated.'
          expect(current_path).to eq user_path(user)
        end
      end
      context 'メールアドレスが未入力時に' do
        before do
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: ''
          fill_in 'user_password', with: 'password2'
          fill_in 'user_password_confirmation', with: 'password2'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗する' do
          expect(page).to have_content "Email can't be blank"
          expect(current_path).to eq user_path(user)
        end
      end
      context '登録済メールアドレスを使用' do
        let!(:user2){ create :user}
        before do
          login(user)
          visit edit_user_path(user)
          fill_in 'user_email', with: user2.email
          fill_in 'user_password', with: 'password2'
          fill_in 'user_password_confirmation', with: 'password2'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗' do
          expect(page).to have_content 'Email has already been taken'
          expect(current_path).to eq user_path(user)
        end
      end
      context '他ユーザーのユーザー編集ページにアクセス' do
        let!(:user2){ create :user}
        before do
          login(user2)
          visit edit_user_path(user)
        end
        it 'アクセスが失敗する' do
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(user2)
        end
      end
      context '他ユーザーのタスク編集ページにアクセス' do
        let!(:user2){ create :user}
        let!(:task){ create(:task, title: 'test2', content: 'content', status: 'todo', deadline: Time.current, user_id: user.id ) }
        it 'アクセスが失敗する' do
          login(user2)
          visit edit_user_path(user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(user2)
        end
      end
    end
  end

  describe 'マイページ' do
    context 'マイページに移動時' do
      let!(:task2){ create(:task, title: 'test2', content: 'content2', status: 'todo', user_id: user.id) }
      before do
        login(user)
        click_link 'Mypage'
      end
      it 'ユーザーのタスクが表示される' do
        expect(page).to have_content(task2.title)
        expect(current_path).to eq user_path(user)
      end
    end
  end
end