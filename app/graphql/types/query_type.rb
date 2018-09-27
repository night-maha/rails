Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

=begin
  field :record, !Types::RecordType do
    description 'Recordのデータ全部もってくる'
    argument :id, !types.ID
    resolve ->(obj, args, ctx) {
      Record.find(args[:id])
    }
  end
=end

#=begin
  field :record, types[Types::RecordType] do
    description 'Recordのデータ全部もってくる'
    #argument :student_id, !types.Int
    resolve ->(obj, args, ctx) {
      Record.where('student_id = ?', ctx[:current_student])
    }
  end
#=end

=begin
  field :record, !Types::RecordType do
    description 'Recordのデータ全部もってくる'
  end

  def record
    Record.all
    end
=end

end
