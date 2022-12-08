# frozen_string_literal: true

file = File.open('input.txt').read
$rows = file.split("\n")
$rows = $rows.map(&:chars)
$trees_per_row = $rows.first.size
$trees_per_col = $rows.size

visible_trees = 0
most_visible_trees = 0

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

def count_trees(height, trees)
  height = height.to_i
  heighest = 0
  tree_count = 0

  trees.each do |tree|
    tree = tree.to_i
    next unless tree >= heighest

    tree_count += 1
    return tree_count if tree >= height

    heighest = tree
  end

  tree_count
end

def calculate_number_of_visible_trees(height, x, y)
  trees_in_row = $rows[y]
  trees_in_column = $rows.map { |row| row[x] }

  if x.zero?
    trees_to_the_left = []
    trees_to_the_right = trees_in_row[1..]
  else
    trees_to_the_left = trees_in_row[0..(x - 1)].reverse
    trees_to_the_right = trees_in_row[(x + 1)..]
  end

  if y.zero?
    trees_above = []
    trees_below = trees_in_column[1..]
  else
    trees_above = trees_in_column[0..(y - 1)].reverse
    trees_below = trees_in_column[(y + 1)..]
  end

  trees_up = count_trees(height, trees_above)
  trees_down = count_trees(height, trees_below)
  trees_left = count_trees(height, trees_to_the_left)
  trees_right = count_trees(height, trees_to_the_right)

  trees_up * trees_left * trees_down * trees_right
end

$rows.each_with_index do |row, y|
  row.each_with_index do |height, x|
    number_of_visible_trees = calculate_number_of_visible_trees(height, x, y)

    most_visible_trees = number_of_visible_trees if number_of_visible_trees > most_visible_trees

    next unless visible?(height, x, y)

    visible_trees += 1
  end
end

puts visible_trees
puts most_visible_trees
