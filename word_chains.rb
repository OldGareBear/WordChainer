require 'set'

class WordChainer
  attr_reader :dictionary
  
  attr_writer :all_seen_words
  
  def initialize(dictionary_file_name)
    dictionary_array = File.readlines(dictionary_file_name).map(&:chomp)
    @dictionary = Set.new(dictionary_array)
    @current_words = []
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
    @current_words << source
    @all_seen_words = { source => nil }
    
    until @current_words.empty?
      new_current_words = explore_current_words(source, target)
      @current_words = new_current_words
    end
    
    return new_current_words
  end
  
  def explore_current_words(source, target)
    new_current_words = []
    
    @current_words.each do |current_word|
      adjacent_words = adjacent_words(current_word)
      
      adjacent_words.each do |adjacent_word|
        next if @all_seen_words.keys.include?(adjacent_word)
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
        
        return build_path(source, target) if @all_seen_words.keys.include?(target)
      end
    end
    
    new_current_words 
  end
  
  def build_path(source, target)
    path = [target]
    parent = ""
    
    until parent == source
      parent = @all_seen_words[path.last]
      path << parent
    end
    
    puts path.reverse
    @current_words = []
  end
  
end

w = WordChainer.new("dictionary.txt")

puts w.run("duck", "ruby")
