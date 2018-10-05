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
    description 'Recordのデータ全部もってくる'
    argument :year, types.Int
    argument :semester, types.Int
    resolve ->(obj, args, ctx) {
      if args[:year].present? && args[:semester].present?
        Record.where('student_id = ? AND year = ? AND semester = ?', ctx[:current_student], args[:year], args[:semester]).order(year: :desc, semester: :desc)
      elsif args[:year].blank? && args[:semester].present?
        Record.where('student_id = ? AND semester = ?', ctx[:current_student], args[:semester]).order(year: :desc, semester: :desc)
      elsif args[:semester].blank? && args[:year].present?
        Record.where('student_id = ? AND year = ?', ctx[:current_student], args[:year]).order(year: :desc, semester: :desc)
      else
        Record.where('student_id = ?', ctx[:current_student]).order(year: :desc, semester: :desc)
      end
    }
  end
#=end


=begin
  if variables[:year].present? && variables[:semester].present?
    field :record, types[Types::RecordType] do
      description 'Recordのデータ全部もってくる'
        argument :year, !types.Int
        argument :semester, !types.Int
        resolve ->(obj, args, ctx) {
          Record.where('student_id = ? AND year = ? AND semester = ?', ctx[:current_student], args[:year], args[:semester]).order(year: :desc, semester: :desc)
        }
      end
  elsif variables[:year].blank? && variables[:semester].present?
    field :record, types[Types::RecordType] do
      description 'Recordのデータ全部もってくる'
        argument :year, !types.Int
        resolve ->(obj, args, ctx) {
          Record.where('student_id = ? AND year = ?', ctx[:current_student], args[:year]).order(year: :desc, semester: :desc)
        }
      end
  elsif variables[:semester].present? && variables[:year].blank?
    field :record, types[Types::RecordType] do
      description 'Recordのデータ全部もってくる'
        argument :semester, !types.Int
        resolve ->(obj, args, ctx) {
          Record.where('student_id = ? AND semester = ?', ctx[:current_student], args[:semester]).order(year: :desc, semester: :desc)
        }
      end
  else
    field :record, types[Types::RecordType] do
      description 'Recordのデータ全部もってくる'
      resolve ->(obj, args, ctx) {
        Record.where('student_id = ?', ctx[:current_student]).order(year: :desc, semester: :desc)
      }
    end
  end
=end

end
