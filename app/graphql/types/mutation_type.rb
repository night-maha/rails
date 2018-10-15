Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  field :CreateRecord, field: Mutations::CreateRecord.field
end