# frozen_string_literal: true

DOWN_DIR = /^\$\scd\s([a-z]+)$/.freeze
FILE = /^([0-9]+).+$/.freeze
DIR = /^dir\s([a-z]+)$/.freeze

file = File.open('input.txt')
lines = file.read.split("\n")

def directory_keys(current_path)
  current_path.split('/')[1..]
end

def directory_size(file_system, current_path)
  if directory_keys(current_path).nil?
    file_system[:_size]
  else
    file_system.dig(*directory_keys(current_path))[:_size]
  end
end

def build_file_system(lines, current_path = '')
  file_system = { _size: 0 }

  lines.each do |line|
    case line
    when '$ cd /'
      # root dir
      current_path = ''
    when '$ cd ..'
      # up dir
      current_path = current_path.split('/')[0..-2].join('/')
    when DOWN_DIR
      # down dir
      current_path += "/#{line.match(DOWN_DIR)[1]}"
    when FILE
      # file
      dir_size = directory_size(file_system, current_path) + line.match(FILE)[1].to_i
      if directory_keys(current_path).nil?
        file_system.merge!({ _size: dir_size })
      else
        file_system.dig(*directory_keys(current_path)).merge!({ _size: dir_size })
      end
    when DIR
      # dir
      if directory_keys(current_path).nil?
        file_system.merge!({ (line.match(DIR)[1]).to_s => { _size: 0 } })
      else
        file_system.dig(*directory_keys(current_path)).merge!({ (line.match(DIR)[1]).to_s => { _size: 0 } })
      end
    end
  end

  file_system
end

def incorporate_subdir_sizes(file_system)
  file_system.each do |key, value|
    next if key == :_size

    file_system[:_size] += incorporate_subdir_sizes(value)
  end

  file_system[:_size]
end

def calc_total(file_system)
  total = file_system[:_size]
  total = 0 if file_system[:_size] > 100_000

  file_system.each do |key, val|
    next if key == :_size

    total += calc_total(val)
  end

  total
end

puts file_system = build_file_system(lines)
incorporate_subdir_sizes(file_system)
puts calc_total(file_system)
