require 'rails_helper'

RSpec.describe User, type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before do
        visit new_user_path
      end
      context 'フォームの入力値が正常' do
        before do
          fill_in 'user_email', with: 'shin@gmail.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成ができる' do
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
          expect(current_path).to_not eq login_path
        end
      end
      context '登録済メールアドレスを使用' do
        let(:user){ create :user }
        before do
          fill_in 'user_email', with: 'test@gamil.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成が失敗する' do
          expect(current_path).to_not eq login_path
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it "マイページへのアクセスが失敗する" do
          get :index
          expect(response).to have_http_status "302"
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー編集' do
      before do
        let(:user){ create :user }
        visit edit_user_path(@user)
      end
      context 'フォームの入力値が正常' do
        before do
          fill_in 'user_email', with: 'tashi@gmail.com'
          fill_in 'user_password', with: 'hoge'
          fill_in 'user_password_confirmation', with: 'hoge'
          click_button 'Update'
        end
        it 'ユーザーの編集ができる' do
          expect(page).not_to have_content 'Login'
        end
      end
    end
    context 'メールアドレスが未入力時に' do
      before do
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: 'hoge'
        fill_in 'user_password_confirmation', with: 'hoge'
        click_button 'Update'
      end
      it 'ユーザーの編集が失敗する' do
        expect(page).not_to have_content 'Login'
      end
    end
    context '登録済メールアドレスを使用' do
      before do
        fill_in 'user_email', with: 'test@gmail.com'
        fill_in 'user_password', with: 'hoge'
        fill_in 'user_password_confirmation', with: 'hoge'
        click_button 'Update'
      end
      it 'ユーザーの編集が失敗' do
        expect(page).not_to have_content 'Login'
      end
    end
    context '他ユーザーの編集ページにアクセス' do
      it 'アクセスが失敗する' do
        get :edit
        expect(response).to have_http_status "302"
      end
    end
  end

  describe 'マイページ' do
    context 'タスクを作成' do
      before do
        let(:user){ create :user }
        let(:task){ create :task }
      end
      it '新規作成したタスクが表示される' do

      end
    end
  end
end