class ExamRecordSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
  #use GraphQL::Batch::Loader
  use(GraphQL::Batch)
  #instrument(:query, GraphQL::Batch::Setup)
  instrument(:field, GraphQL::Models::Instrumentation.new)
  lazy_resolve(Promise, :sync)
end
