Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  field :CreateRecord, field: Mutations::CreateRecord.field
  field :UpdateRecord, field: Mutations::UpdateRecord.field
  field :DeleteRecord, field: Mutations::DeleteRecord.field
end