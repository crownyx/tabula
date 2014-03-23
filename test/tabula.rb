require '../../solea/solea'
require '../tabula'

Solea.test do
  table = Tabula.new(%(
      Name | Age | Hair Color |
      John | 30  | brown      |
      Mary | 28  | blonde     |
      Jane | 29  | black      |
  ))

  example table 
  expect  [["John", "30", "brown"], ["Mary", "28", "blonde"], ["Jane", "29", "black"]]
  #example { table.colheads }
  #expect  { ["Name", "Age", "Hair Color"] }
  #example { table.rowheads }
  #expect  { [] }
  #example { table.columns }
  #expect  { [["John", "Mary", "Jane"], ["30", "28", "29"], ["brown", "blonde", "black"]] }
  #example { table[1]["Age"] }
  #expect  { "28" }
  #example { table.sort_columns![2] }
  #expect  { ["29", "black", "Jane"] }
  #example { table.colheads }
  #expect  { ["Age", "Hair Color", "Name"] }
  #example { table[2]["Hair Color"] }
  #expect  { "black" }
  #example { table[0][0] }
  #expect  { "30" }
  #example { table.modify_values(in_column: "Age", &:to_i)[1][0] }
  #expect  { 28 }
  #example { table[2]["Age"] }
  #expect  { 29 }

  #example { table.to_s indent: 10 }
  #expect  {%(
  #        +=====+============+======+
  #        | Age | Hair Color | Name |
  #        +-----+------------+------+
  #        | 30  | brown      | John |
  #        +-----+------------+------+
  #        | 28  | blonde     | Mary |
  #        +-----+------------+------+
  #        | 29  | black      | Jane |
  #        +=====+============+======+)[1..-1]}
  #
  #table = Tabula.new(%(
  #    Name | Age | Hair Color |
  #    John | 30  | brown      |
  #    Mary | 28  | blonde     |
  #))

  #example { table.to_s indent: 10 }
  #expect  {%(
  #        +======+=====+============+
  #        | Name | Age | Hair Color |
  #        +------+-----+------------+
  #        | John | 30  | brown      |
  #        +------+-----+------------+
  #        | Mary | 28  | blonde     |
  #        +======+=====+============+)[1..-1]}

  #table = Tabula.new(%(
  #         | Age | Hair Color |
  #    John | 30  | brown      |
  #    Mary | 28  | blonde     |
  #    Jane | 29  | black      |
  #  ), rowheads: true)

  #example { table }
  #expect  { [["30", "brown"], ["28", "blonde"], ["29", "black"]] }
  #example { table.colheads }
  #expect  { ["Age", "Hair Color"] }
  #example { table.rowheads }
  #expect  { ["John", "Mary", "Jane"] }
  #example { table.columns }
  #expect  { [["30", "28", "29"], ["brown", "blonde", "black"]] }
  #example { table[2]["Hair Color"] }
  #expect  { "black" }
  #example { table["Mary"]["Age"] }
  #expect  { "28" }
  #example { table[0][0] }
  #expect  { "30" }
  #example { table.modify_values(in_column: 0, &:to_i)["Jane"]["Age"] }
  #expect  { 29 }

  #example { table.to_s indent: 10 }
  #expect  {%(
  #               +=====+============+
  #               | Age | Hair Color |
  #        +------+-----+------------+
  #        | John | 30  | brown      |
  #        +------+-----+------------+
  #        | Mary | 28  | blonde     |
  #        +------+-----+------------+
  #        | Jane | 29  | black      |
  #        +======+=====+============+)[1..-1]}

  #table.colheads = ["edad", "color de cabello"]

  #example { table.to_s indent: 10 }
  #expect  {%(
  #               +======+==================+
  #               | edad | color de cabello |
  #        +------+------+------------------+
  #        | John | 30   | brown            |
  #        +------+------+------------------+
  #        | Mary | 28   | blonde           |
  #        +------+------+------------------+
  #        | Jane | 29   | black            |
  #        +======+======+==================+)[1..-1]}

  #table.rowheads = ["Juan", "Maria", "Juana"]

  #example { table.to_s indent: 10 }
  #expect  {%(
  #                +======+==================+
  #                | edad | color de cabello |
  #        +-------+------+------------------+
  #        | Juan  | 30   | brown            |
  #        +-------+------+------------------+
  #        | Maria | 28   | blonde           |
  #        +-------+------+------------------+
  #        | Juana | 29   | black            |
  #        +=======+======+==================+)[1..-1]}
end

#if $0 == __FILE__
#  Solea.run_tests
#  Solea.basic_report
#end
