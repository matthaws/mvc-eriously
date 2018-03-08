# frozen_string_literal: true

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.to_s.camelcase.singularize.constantize
  end

  def table_name
    self.class_name.downcase.to_s.underscore + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
      self.foreign_key = options[:foreign_key] || "#{name.downcase}_id".to_sym
      self.primary_key = options[:primary_key] || :id
      self.class_name = options[:class_name] || name.to_s.capitalize
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.foreign_key = options[:foreign_key] || "#{self_class_name.downcase}_id".to_sym
    self.primary_key = options[:primary_key] || :id
    self.class_name = options[:class_name] || name.to_s.singularize.capitalize
  end
end

module Associatable
  def assoc_options
    @assoc_options ||= {}
  end

  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name.to_sym) do
      b_t_options = self.assoc_options[name]
      foreign_key = self.send(b_t_options.foreign_key)
      results = DBConnection.execute(<<-SQL, foreign_key)
        SELECT
          *
        FROM
          #{b_t_options.table_name}
        WHERE
          #{b_t_options.primary_key} = ?
      SQL

      b_t_options.model_class.parse_all(results).first
    end
  end

  def has_many(name, options = {})
    define_method(name.to_sym) do
      h_m_options = HasManyOptions.new(name, self.class.to_s, options)
      primary_key = self.send(h_m_options.primary_key)
      results = DBConnection.execute(<<-SQL, primary_key)
        SELECT
          *
        FROM
          #{h_m_options.table_name}
        WHERE
          #{h_m_options.foreign_key} = ?
      SQL

      h_m_options.model_class.parse_all(results)
    end
  end

  def has_one_through(name, through_name, source_name)
  define_method(name) do
    through_options = self.class.assoc_options[through_name]
    source_options = through_options.model_class[source_name]
    foreign_key = self.send(through_options.foreign_key)
    results = DBConnection.execute(<<-SQL, foreign_key)
      SELECT
        #{source_options.table_name}.*
      FROM
        #{through_options.table_name}
      JOIN
        #{source_options.table_name}
      ON
        #{through_options.table_name}.#{through_options.foreign_key} = #{source_options.table_name}.#{source_options.primary_key}
      WHERE
        #{through_options.table_name}.#{through_options.primary_key} = ?
    SQL

    source_options.model_class.parse_all(results)
  end
end

end
