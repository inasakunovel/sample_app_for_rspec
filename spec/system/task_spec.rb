require 'rails_helper'
require 'support/login_macros'

RSpec.describe 'Task', type: :system do
  let(:user){ create :user }
  describe 'ログイン前' do
    describe 'マイページ' do
      context 'ログインしていない状態' do
        before do
          visit new_task_path
        end
        it "タスク新規画面へのアクセスが失敗する" do
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
        before do
          visit edit_user_path(user)
        end
        it "タスク編集画面へのアクセスが失敗する" do
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    context 'タスクを作成' do
      before do
        login(user)
        click_link 'New Task'
        fill_in 'Title', with: 'test_title'
        fill_in 'Content', with: 'content'
        select 'done', from: 'Status'
        fill_in 'Deadline', with: Time.current
        click_button 'Create Task'
      end
      it 'タスクの新規作成が成功する' do
        expect(page).to have_content('Task was successfully created.')
        expect(page).to have_content('test_title')
        expect(current_path).to eq task_path(user)
      end
    end
    context 'タスクを編集' do
      let!(:task2){ create(:task, title: 'test2', content: 'content2', status: 'todo', user_id: user.id) }
      before do
        login(user)
        click_link 'Edit'
        expect(current_path).to eq edit_task_path(user)
        fill_in 'Title', with: 'test_title2'
        fill_in 'Content', with: 'test_content2'
        select 'todo', from: 'Status'
        fill_in 'Deadline', with: Time.current
        click_button 'Update Task'
      end
      it '編集が成功する' do
        expect(page).to have_content('Task was successfully updated.')
        expect(page).to have_content('test_title2')
        expect(current_path).to eq task_path(user)
      end
    end
    context 'タスクを削除' do
      let!(:task2){ create(:task, title: 'test2', content: 'content2', status: 'todo', user_id: user.id) }
      before do
        login(user)
        click_link 'Mypage'
        click_link 'Destroy'
        page.driver.browser.switch_to.alert.accept
      end
      it '削除が成功する' do
        expect(page).to have_content('Task was successfully destroyed.')
        expect(page).to_not have_content('test2')
        expect(current_path).to eq tasks_path
      end
    end
  end
end