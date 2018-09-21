Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :record, !Types::RecordType do
      description 'Recordのデータ全部もってくる'
      argument :id, !types.ID
      resolve ->(obj, args, ctx) {
        Record.find(args[:id])
      }
  end
end
