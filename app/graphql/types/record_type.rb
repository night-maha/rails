Types::RecordType = GraphQL::ObjectType.define do
  name "Record"

  field :id, types.ID, description: '成績ID'
  field :student_id, types.Int, description: '生徒番号'
  field :jpn, types.Int, description: '国語'
  field :math, types.Int, description: '数学'
  field :eng, types.Int, description: '英語'
  field :sci, types.Int, description: '理科'
  field :soc, types.Int, description: '社会'
  field :year, types.Int, description: '年'
  field :semester, types.Int, description: '学期'
  field :created_at, ScalarTypes::DateTime, description: '作成日時'
  field :updated_at, ScalarTypes::DateTime, description: '更新日時'
end



=begin
    field :id, types.ID, description: '成績ID', null: false
    field :student_id, types.Int, description: '生徒番号', null: true
    field :jpn, types.Int, description: '国語', null: true
    field :math, types.Int, description: '数学', null: true
    field :eng, types.Int, description: '英語', null: true
    field :sci, types.Int, description: '理科', null: true
    field :soc, types.Int, description: '社会', null: true
    field :year, types.Int, description: '年', null: true
    field :semester, types.Int, description: '学期', null: true
    field :created_at, ScalarTypes::DateTime, description: '作成日時', null: false
    field :updated_at, ScalarTypes::DateTime, description: '更新日時', null: false
=end


