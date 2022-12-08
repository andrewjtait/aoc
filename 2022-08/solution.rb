# frozen_string_literal: true

file = File.open('input.txt').read
$rows = file.split("\n")
$rows = $rows.map(&:chars)
$trees_per_row = $rows.first.size
$trees_per_col = $rows.size

visible_trees = 0

def visible?(height, x, y)
  return true if x.zero?
  return true if (x + 1) == $trees_per_row
  return true if y.zero?
  return true if (y + 1) == $trees_per_col

  blocked_from_left = false
  blocked_from_right = false
  blocked_from_top = false
  blocked_from_bottom = false

  # check each column in row y
  row = $rows[y]
  row.each_with_index do |comparative_height, index|
    blocked_from_left = true if index < x && comparative_height >= height
    blocked_from_right = true if index > x && comparative_height >= height
  end

  # check each row in column x
  $rows.each_with_index do |row, index|
    comparative_height = row[x]
    blocked_from_top = true if index < y && comparative_height >= height
    blocked_from_bottom = true if index > y && comparative_height >= height
  end

  !(blocked_from_top && blocked_from_left && blocked_from_right && blocked_from_bottom)
end

$rows.each_with_index do |row, y|
  row.each_with_index do |height, x|
    next unless visible?(height, x, y)

    visible_trees += 1
  end
end

puts visible_trees
