require_relative '../db/db_connection'
require_relative './associations'
require 'active_support/inflector'

# frozen_string_literal: true

class ModelBase
  extend Associatable
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        self.attributes[column]
      end

      define_method("#{column}=".to_sym) do |value|
        self.attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    all = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    self.parse_all(all)
  end

  def self.parse_all(results)
    all = []
    results.each do |result|
      all << self.new(result)
    end

    all
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL
    self.parse_all(result).first
  end

  def self.where(params)
    keys = params.keys
    values = keys.map { |key| params[key] }
    search_results = DBConnection.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{keys.map {|key| "#{key} = ?"}.join(' AND ')}
    SQL

    self.parse_all(search_results)
  end

  def initialize(params = {})
    params.keys.each do |attr_name|
      unless self.class.columns.include?(attr_name.to_sym)
        raise Exception.new("unknown attribute '#{attr_name}'")
      end

      self.send("#{attr_name}=".to_sym, params[attr_name])
    end

  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
  end


  def save
    if self.id.nil?
      self.insert
    else
      self.update
    end
  end

  private
  def insert
    attribute_values = []
    self.class.columns.each do |col|
      attribute_values << self.send(col)
    end
    col_names = self.class.columns.join(", ")
    question_marks = (["?"] * self.class.columns.length).join(", ")

    new_record = DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
    #{self.class.table_name} (#{col_names})
    VALUES
    (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    attribute_values = []
    self.class.columns.each do |col|
      attribute_values << self.send(col)
    end
    attribute_values << self.id
    set_line = self.class.columns.map { |col| "#{col} = ?"}.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
    UPDATE
      #{self.class.table_name}
    SET
      #{set_line}
    WHERE
      id = ?
    SQL
  end
end
