require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'パリデーションテスト' do
    let(:user){ create :user }

    describe 'タイトルのバリデーションテスト' do
      context 'title presence:trueチェック' do

        it 'タイトルが空の時にエラーになる' do
          task = build(:task, title: '', status: 'todo', user_id: user.id)
          expect(task).to_not be_valid
        end

        it 'タイトルが入っている時に登録できる' do
          task = build(:task, title: 'タイトル', status: 'todo', user_id: user.id)
          expect(task).to be_valid
        end
      end

      context 'title uniqueness:trueチェック' do
        before do
          create(:task, title: 'タイトル', status: 'todo', user_id: user.id)
        end

        it 'タイトルが重複している時エラーになる' do
          task = build(:task, title: 'タイトル', status: 'todo', user_id: user.id)
          expect(task).to_not be_valid
        end

        it 'タイトルが重複していないと登録できる' do
          task = build(:task, title: 'タイトル1', status: 'todo', user_id: user.id)
          expect(task).to be_valid
        end
      end
    end

    describe 'ステータスのバリデーションテスト' do
      context 'status presence:trueチェック' do
        it 'ステータスが空の時にエラーになる' do
          task = build(:task,  title: 'タイトル', status: '', user_id: user.id)
          expect(task).to_not be_valid
        end

        it 'ステータスが入っている時に登録できる' do
          task = build(:task, title: 'タイトル', status: 'todo', user_id: user.id)
          expect(task).to be_valid
        end
      end
    end
  end
end