Types::StudentType = GraphQL::ObjectType.define do
  name "Student"

  field :id, types.ID, description: 'ユーザID'
  field :student_id, types.Int, description: '生徒番号'
  field :name, types.String, description: '名前'
  field :sex, types.String, description: '性別'
  field :birthday, ScalarTypes::DateTime, description: '生年月日'
  connection :records, Types::RecordType.connection_type do
  #field :record, types[Types::RecordType] do
    argument :student_id, types.Int
    argument :year, types.Int
    argument :semester, types.Int

    resolve ->(obj, args, ctx) {
      Rails.logger.debug obj.inspect
      #Loaders::AssociationLoader.for(Student, :record).load(obj)
      if args[:year].present? && args[:semester].present?
        Record.where('year = ? AND semester = ? AND student_id = ?', args[:year], args[:semester], obj.student_id).order(year: :desc, semester: :desc)
      elsif args[:year].blank? && args[:semester].present?
        Record.where('semester = ? AND student_id = ?', args[:semester], obj.student_id).order(year: :desc, semester: :desc)
      elsif args[:semester].blank? && args[:year].present?
        Record.where('year = ? AND student_id = ?', args[:year], obj.student_id).order(year: :desc, semester: :desc)
      else
        Loaders::AssociationLoader.for(Student, :record).load(obj)
        #Record.where('student_id = ?', obj.student_id).order(year: :desc, semester: :desc)
      end

    }
  end
=begin
  def records
    Rails.logger.debug "hoge"
    Loaders::AssociationLoader.for(Student, :record).load(object)
  end
=end
end

=begin
exam = Loaders::AssociationLoader.new(Record, where:['student_id = ?', obj.student_id])
exam.load(obj.student_id)
exam.perform(obj.student_id)
=end