Mutations::UpdateRecord = GraphQL::Relay::Mutation.define do
  name "UpdateRecord"

  return_field :record, Types::RecordType

  input_field :id, types.ID
  input_field :jpn, types.Int
  input_field :math, types.Int
  input_field :eng, types.Int
  input_field :sci, types.Int
  input_field :soc, types.Int

  resolve ->(obj, args, ctx) {
     record = Record.find(args[:id])
     record.update(jpn: args[:jpn], math: args[:math], eng: args[:eng], sci: args[:sci], soc: args[:soc])

    {record: record}
  }

end
