Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

=begin
  field :record, types[Types::RecordType] do
    description 'Recordのデータ全部もってくる'
      #argument :year, !types.Int
      #argument :semester, !types.Int
      resolve ->(obj, args, ctx) {
        Record.where('student_id = ?', ctx[:current_student]).order(year: :desc, semester: :desc)
    }
  end
=end

#=begin
  field :record, types[Types::RecordType] do
    argument :student_id, types.Int
    argument :year, types.Int
    argument :semester, types.Int
    resolve ->(obj, args, ctx) {
      if ctx[:current_student].present?
        if args[:year].present? && args[:semester].present?
          Record.where('student_id = ? AND year = ? AND semester = ?', ctx[:current_student], args[:year], args[:semester]).order(year: :desc, semester: :desc)
        elsif args[:year].blank? && args[:semester].present?
          Record.where('student_id = ? AND semester = ?', ctx[:current_student], args[:semester]).order(year: :desc, semester: :desc)
        elsif args[:semester].blank? && args[:year].present?
          Record.where('student_id = ? AND year = ?', ctx[:current_student], args[:year]).order(year: :desc, semester: :desc)
        else
          Record.where('student_id = ?', ctx[:current_student]).order(year: :desc, semester: :desc)
        end
      else
        if args[:year].present? && args[:semester].present?
          Record.where('year = ? AND semester = ?', args[:year], args[:semester]).order(year: :desc, semester: :desc)
        elsif args[:year].blank? && args[:semester].present?
          Record.where('semester = ?', args[:semester]).order(year: :desc, semester: :desc)
        elsif args[:semester].blank? && args[:year].present?
          Record.where('year = ?', args[:year]).order(year: :desc, semester: :desc)
        else
          Record.all.order(year: :desc, semester: :desc)
        end
      end
    }
  end
#=end

  field :student, types[Types::StudentType] do
    argument :student_id, types.Int
    argument :year, types.Int
    argument :semester, types.Int
    resolve ->(obj, args, ctx) {
      Student.all
    }
  end

=begin
  connection :record, types[Types::RecordType].connection_type do
    argument :year, types.Int
    argument :semester, types.Int
    resolve ->(obj, args, ctx) {
      Record.where('year = ? AND semester = ?', args[:year], args[:semester]).order(year: :desc, semester: :desc)
    }
  end
=end
end
