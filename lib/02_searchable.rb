require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    t_name = self.table_name
    where_line = params.keys.map { |el| "#{el} = ?"}.join(" AND ")
    field_value = params.values
    results = DBConnection.execute(<<-SQL, field_value)
    SELECT
      *
    FROM
      #{t_name}
    WHERE
      #{where_line}
  SQL
    results.map { |attrs| self.new(attrs) }
  end
end

class SQLObject
  extend Searchable
end
