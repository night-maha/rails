class Loaders::RecordLoader < GraphQL::Batch::Loader
  def initialize(record, where: nil)
    @model = record
    @column = "student_id"
    @column_type = record.type_for_attribute(@column)
    @where = where
  end

  def load(key)
    super(@column_type.cast(key))
  end

  def perform(keys)
    Rails.logger.debug keys
    query(keys).each do |record|
      value = @column_type.cast(record.public_send(@column))
      fulfill(value, record)
    end
    keys.each { |key| fulfill(key, nil) unless fulfilled?(key) }
  end

  private

  def query(keys)
    scope = @model
    scope = scope.where(@where) if @where
    scope.where(@column => keys)
  end
end