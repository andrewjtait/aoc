# frozen_string_literal: true

DOWN_DIR = /^\$\scd\s([a-z]+)$/.freeze
FILE = /^([0-9]+).+$/.freeze
DIR = /^dir\s([a-z]+)$/.freeze

file = File.open('input.txt')
lines = file.read.split("\n")

def build_directories(lines, current_path = ['/'])
  directories = { '/' => 0 }

  lines.each do |line|
    case line
    when '$ cd /'
      # root dir
      current_path = ['/']
    when '$ cd ..'
      # up dir
      current_path = current_path[0..-2]
    when DOWN_DIR
      # down dir
      current_path << line.match(DOWN_DIR)[1]
    when FILE
      current_path.each_with_index do |_dir, index|
        directories[current_path[0..index].join('/')] ||= 0
        directories[current_path[0..index].join('/')] += line.match(FILE)[1].to_i
      end
    end
  end

  directories
end

directories = build_directories(lines)

total = 0

directories.each do |_key, value|
  total += value unless value > 100_000
end
puts total

directories = directories.values.sort

used_space = (70_000_000 - directories.last)
required_space = (30_000_000 - used_space)

directory_size_to_delete = directories.find do |val|
  val > required_space
end

puts directory_size_to_delete
