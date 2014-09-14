require 'set'

class WordChainer
  attr_reader :dictionary
  
  def initialize(dictionary_file_name)
    dictionary_array = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = Set.new(dictionary_array)
  end
  
  def adjacent_words(word)
    sub_dictionary = dictionary.select { |entry| entry.length == word.length }
    adjacents = []
    
    sub_dictionary.each do |entry|
      letters_off = 0
      entry.each_char.with_index do |letter, letter_position|
        letters_off += 1 unless word[letter_position] == letter
      end
      adjacents << entry if letters_off == 1
    end
    
    adjacents
  end
  
  
  def run(source, target)
  end
  
end

