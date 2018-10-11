Mutations::CreateRecord = GraphQL::Relay::Mutation.define do
  name "CreateRecord"

  return_field :record, Types::RecordType

  input_field :jpn, types.Int
  input_field :math, types.Int
  input_field :eng, types.Int
  input_field :sci, types.Int
  input_field :soc, types.Int
  input_field :year, !types.Int
  input_field :semester, !types.Int

  resolve ->(obj, args, ctx) {
    { record: Record.create(
        student_id: ctx[:current_student],
        jpn: args[:jpn],
        math: args[:math],
        eng: args[:eng],
        sci: args[:sci],
        soc: args[:soc],
        year: args[:year],
        semester: args[:semester]) }
  }
end