require 'rails_helper'

RSpec.describe 'Task', type: :system do
  let(:user){ create :user }
  let(:task){ create(:task, user_id: user.id) }
  describe 'ログイン前' do
    describe 'マイページ' do
      context 'タスク新規画面へアクセス' do
        it "アクセスが失敗する" do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
      context 'タスク編集画面へアクセス' do
        it "アクセスが失敗する" do
          visit edit_user_path(user)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      login(user)
      visit tasks_path
    end
    describe 'タスクを作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          click_link 'Mypage'
          click_link 'New task'
          fill_in 'Title', with: 'new_title'
          fill_in 'Content', with: 'new_content'
          select 'done', from: 'Status'
          fill_in 'Deadline', with: Time.current
          click_button 'Create Task'
          expect(page).to have_content('Task was successfully created.')
          expect(page).to have_content('new_title')
          expect(current_path).to eq task_path(user)
        end
      end
    end
    describe 'タスクを編集' do
      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          task
          click_link 'Mypage'
          find('table').click_link('Edit')
          fill_in 'Title', with: 'title_after'
          fill_in 'Content', with: 'content_after'
          select 'doing', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content('Task was successfully updated.')
          expect(page).to have_content('title_after')
          expect(current_path).to eq task_path(user)
        end
      end
    end
    describe 'タスクを削除' do
      context '削除ボタンをクリック' do
        it 'タスクの削除が成功する' do
          task
          click_link 'Mypage'
          click_link 'Destroy'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content('Task was successfully destroyed.')
          expect(page).to_not have_content('destroy_title')
          expect(current_path).to eq tasks_path
        end
      end
    end
  end
end