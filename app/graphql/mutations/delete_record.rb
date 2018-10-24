Mutations::DeleteRecord = GraphQL::Relay::Mutation.define do
  name "DeleteRecord"

  input_field :id, types.ID.to_list_type

  return_field :deletedId, !types.ID
  return_field :errors, types.String

  resolve ->(obj, args, ctx) {
    comment = Record.where('id IN (?)', args[:id])
    return { errors: 'Comment not found' } if comment.nil?

    comment.delete_all
    {deletedId: args[:id] }
  }
end
