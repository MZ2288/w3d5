require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    t_name = table_name
    items =  DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      "#{t_name}"
  SQL
    items = items.first
    items.map { |el| el.gsub(" ", "_") }.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method("#{column}=") do |value|
        attributes[column] = value
      end
      define_method("#{column}") do
        attributes[column]
      end
    end
  end

  def self.table_name=(table_name)
    define_method("#{table_name}=") do |value|
      instance_variable_set("@#{table_name}", value)
    end
  end

  def self.table_name
    "#{self.to_s.downcase}s"
  end

  def self.all
    t_name = table_name
    results = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      "#{t_name}"
  SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map do |attrs|
      self.new(attrs)

    end
  end

  def self.find(id)
    t_name = table_name
    item =  DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      "#{t_name}"
    WHERE
      id = "#{id}"
    LIMIT
      1
  SQL
    return nil if item.empty?
    self.new(item.first)
  end

  def initialize(params = {})
    params.each do |name, v|
      name_symbol = name.to_sym
      unless self.class::columns.include?(name_symbol)
        raise "unknown attribute '#{name}'"
      end
      self.send("#{name}=", v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
