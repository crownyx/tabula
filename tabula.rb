class Array
  def intersperse obj
    (2..self.length).reverse_each do |i|
      self.insert -i, obj
    end
  end
end

class Tabula < Array

  def initialize table_string = nil, colheads: nil, rows: nil, csv: false
    if table_string
      if csv
        table_array = table_string.split(/\r?\n/).map { |row| row.split(/ *, */) }
      else
        table_array = table_string.gsub(/\A[\W&&[^\|]]*\| /, '').gsub(/ \|[\W&&[^\|]]*\z/, '').split(/ \|\n[\W&&[^\|]]*\| /).map do |row|
                        row.split(/ \| /).map &:strip
                      end
      end
      @colheads = table_array.shift
      self.replace table_array.map { |row| Hash[@colheads.zip(row)] }
    end
    @colheads = colheads if colheads
    @rows     = rows     if rows
  end

  def add_rows *rows
    self.concat(rows.map do |row|
      self.colheads.zip(row).to_h
    end)
  end

  alias add_row add_rows

  def delete_rows *rows
    self.reject! do |own_row|
      rows.find do |row|
        row == own_row
      end
    end
  end

  alias delete_row delete_rows

  def colheads
    self[0].keys
  end

  def columns
    Hash[self.colheads.zip(self.map(&:values).transpose)]
  end

  def add_column index, *colheads, &block
    self.map! do |row|
      Hash[row.to_a.insert(index,
        *colheads.zip(colheads.map do
          block.call(row) if block_given?
        end))]
    end
  end

  alias add_columns add_column

  def delete_column *colheads
    self.map! do |row|
      row.delete_if do |key, value|
        colheads.include? key
      end
    end
  end

  alias delete_columns delete_column

  def modify_values *colheads, &block
    self.each do |row|
      if colheads.any?
        colheads.each do |colhead|
          row[colhead] = block.call(row[colhead])
        end
      else
        row.each do |key, value|
          row[key] = block.call(value)
        end
      end
    end
  end

  def modify_colheads colhead = "all", &block
    self.map! do |row|
      Hash[row.keys.map do |key|
        key == colhead || colhead =~ /all/i ? block.call(key) : key
      end.zip(row.values)]
    end
  end

  def to_s indent: 0
    if self.any?
      lengths = [*self.columns].map do |column|
        column.flatten(1).compact.map(&:to_s).max_by(&:length).length if column.any?
      end.compact

      [self.colheads, *self.map(&:values)].map do |row|
        row.map.with_index do |value, i|
          # i += 1 if row.length < lengths.length
          value ||= ""
          value.to_s.ljust lengths[i]
        end.join(" | ").prepend("| ").concat(" |")
      end.tap do |arr|
        arr.intersperse arr[1].gsub("|", "+").gsub(/[^+]/, "-")
      end.tap do |arr|
        arr.unshift arr[0].gsub("|", "+").gsub(/[^+]/, "=")
        arr.push arr[2].gsub("-", "=")
      end.tap do |arr|
        arr.map! { |row| row.rjust(arr[-1].length) }
      end.join("\n#{" " * indent}").prepend(" " * indent)
    else
      self.colheads.map do |colhead|
        " #{colhead} "
      end.join("|").prepend("|").concat("|")
      .prepend(self.colheads.map do |colhead|
        " #{colhead} ".gsub(/./, '=')
      end.join("+").prepend("+").concat("+\n"))
      .concat(self.colheads.map do |colhead|
        " #{colhead} ".gsub(/./, '=')
      end.join("+").prepend("\n+").concat("+"))
    end
  end

  def to_csv
    [self.colheads, *self.map(&:values)].map { |row| row.join(',') }.join("\n")
  end
end

class Array
  def to_tabula
    if self.all? { |el| el.is_a? Hash }
      Tabula.new.replace(self)
    else
      self.map { |el| Hash[el] }.to_tabula
    end
  end
end

class TabulaWithRowheads < Hash
  def initialize table_string = nil, colheads: true
    if table_string
      table_array = table_string.gsub(/\A[\W&&[^\|]]*\| /, '').gsub(/ \|[\W&&[^\|]]*\z/, '').split(/ \|\n[\W&&[^\|]]*\| /).map do |row|
                      row.split(/ \| /).map &:strip
                    end
      if colheads
      else
        self.replace Hash[table_array.map { |row| [row.shift, *row] }]
      end
    end
  end

  def to_s indent: 0
    lengths = [*self.to_a.transpose].map do |column|
      column.map(&:to_s).max_by(&:length).length
    end

    self.map do |row|
      row.map.with_index do |value, i|
        # i += 1 if row.length < lengths.length
        value ||= ""
        value.to_s.ljust lengths[i]
      end.join(" | ").prepend("| ").concat(" |")
    end.tap do |arr|
      arr.intersperse arr[1].gsub("|", "+").gsub(/[^+]/, "-")
    end.tap do |arr|
      arr.unshift arr[0].gsub("|", "+").gsub(/[^+]/, "=")
      arr.push arr[2].gsub("-", "=")
    end.tap do |arr|
      arr.map! { |row| row.rjust(arr[-1].length) }
    end.join("\n#{" " * indent}").prepend(" " * indent)
  end
end

class Hash
  def to_tabula
    TabulaWithRowheads.new.replace self
  end
end
