require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'パリデーション確認' do

    context '正常値の場合' do
      it 'バリデーションエラーが発生しない' do
        task = build(:task)
        expect(task).to be_valid
      end
    end

    context 'タイトルが空の場合' do
      it 'バリデーションエラーになる' do
        task = build(:task, title: '', status: 'todo')
        expect(task).to_not be_valid
        expect(task.errors.messages[:title]).to include("can't be blank")
      end
    end

    context 'タイトルが重複している場合' do
      it 'バリデーションエラーになる' do
        create(:task, title: 'unique_title')
        duplicated_task = build(:task, title: 'unique_title', status: 'todo')
        expect(duplicated_task).to_not be_valid
        expect(duplicated_task.errors.messages[:title]).to include('has already been taken')
      end
    end

    context 'タイトルが重複していない場合' do
      it 'バリデーションエラーが発生しない' do
        task = build(:task, title: 'タイトル1', status: 'todo')
        expect(task).to be_valid
      end
    end

    context 'ステータスが空の場合' do
      it 'バリデーションエラーになる' do
        task = build(:task,  title: 'タイトル', status: '')
        expect(task).to_not be_valid
        expect(task.errors.messages[:status]).to include("can't be blank")
      end
    end
  end
end