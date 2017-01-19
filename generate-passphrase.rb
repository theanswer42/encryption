#!/usr/bin/ruby
#
# http://xkcd.com/936/
# This will generate a new passphrase based on the alternative Diceware word
# list by Alan Beale. The list is here:
# http://world.std.com/%7Ereinhold/beale.wordlist.asc
#
# For the procedure to generate the passphrase, see here:
# http://world.std.com/~reinhold/diceware.html
#
# Copied from here:

# 1. Download the complete Diceware list or the alternative Beale list and save it on your computer. Print it out if you like. Then return to this page.
# 2. Decide how many words you want in your passphrase. A five word passphrase provides a level of security much higher than the simple passwords most people use. We recommend a minimum of six words for use with GPG, wireless security and file encryption programs. A seven, eight or nine word pass phrase is recommended for high value uses such as whole disk encryption, BitCoin, and the like. For more information, see the Diceware FAQ.
# 3. Now roll the dice and write down the results on a slip of paper. Write the numbers in groups of five. Make as many of these five-digit groups as you want words in your passphrase. You can roll one die five times or roll five dice once, or any combination in between. If you do roll several dice at a time, read the dice from left to right.
# 4. Look up each five digit number in the Diceware list and find the word next to it. For example, 21124 means your next passphrase word would be "clip" (see the excerpt from the list, above).
# 5. When you are done, the words that you have found are your new passphrase. Memorize them and then either destroy the scrap of paper or keep it in a really safe place. That's all there is to it!

# For extra security without adding another word, insert one special character or digit chosen at random into your passphrase. Here is how to do this securely: Roll one die to choose a word in your passphrase, roll again to choose a letter in that word. Roll a third and fourth time to pick the added character from the following table:

#  Third Roll
        
#     1 2 3 4 5 6
# F 1 ~ ! # $ % ^
# o 2 & * ( ) - =
# u 3 + [ ] \ { }
# r 4 : ; " ' < >
# t 5 ? / 0 1 2 3
# h 6 4 5 6 7 8 9

WORDLIST_NAME="beale.wordlist.asc"
SPECIAL_TABLE =  [%w(~ ! # $ % ^), %w(& * ( ) - =), %w(+ [ ] \ { }), %w(: ; " ' < >), %w(? / 0 1 2 3), %w(4 5 6 7 8 9)]
class PhraseGenerator
  attr_reader :wordlist
  def initialize
    # We assume that the list is in the same directory as this program
    list_filename = File.join(File.dirname(__FILE__), WORDLIST_NAME)
    lines = File.read(list_filename).split("\n")
    @wordlist = {}
    lines.each do |line|
      m = line.match(/^(\d{5})\t(\S*)$/)
      next unless m
      
      @wordlist[m[1]] = m[2]      
    end
    
  end

  def roll(count)
    roll = (1..count).collect {|i| Random.rand(5) + 1 }
  end
  
  def get_word
    wordlist[roll(5).join("")]
  end
  
  def get_passphrase(options={})
    count = options[:count] || 6
    words = (1..count).collect {|i| get_word }
    if options[:special]
      special_roll = nil
      while true
        special_roll = roll(4)
        if special_roll[0] <= words.length &&
           special_roll[1] <= words[special_roll[0]-1].length
          break
        end
      end
      words[special_roll[0]-1][special_roll[1]-1] = SPECIAL_TABLE[special_roll[3]-1][special_roll[2]-1]
    end
    words.join(" ")
  end
end

p = PhraseGenerator.new
options = {special: true}
count = ARGV[0].to_i
options[:count] = count if count > 0
puts p.get_passphrase(options)
