class ExamRecordSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  lazy_resolve(Promise, :sync)
  #instrument(:query, GraphQL::Batch::Setup)
  #instrument(:field, GraphQL::Models::Instrumentation.new)
end
