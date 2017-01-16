#!/usr/bin/ruby

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


WORDLIST_NAME="beale.wordlist.asc"

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

  def get_word
    roll = (1..5).collect {|i| Random.rand(5) + 1 }.join("")
    wordlist[roll]
  end
  
  def get_passphrase(words=6)
    (1..words).collect {|i| get_word }.join(" ")
  end
end

p = PhraseGenerator.new()
puts p.get_passphrase
