#Create a hash function for each type of input data. Arrays, Strings, etc.

#XORing two numbers gives you a unique number using binary digits.
# by using the unique index of an element in an array, you can create
# a unique hash_value.
class Array
  def hash
    hash_value = 0
    self.each_with_index do |el,i|
      hash_value = hash_value^(el.hash+i)  #the hash_value is updated for each new element.
    end
    hash_value
  end
end



class String
  def hash
    hash_value = 0
    self.chars.each_with_index do |el,i|
      hash_value = hash_value^(el.ord+i)
    end
    hash_value
  end
end


#For hashes, you want {1: a, 2: c} to return the same value as
#{2: c, 1: a}

class Hash
  # This returns 0 because rspec will break if it returns nil
  def hash
    hash_value = 0
    self.each do |key,value|
      hash_value = hash_value^(key.hash+value.hash)  #XOR is commutative!
      #ex: 6^7^5 === 7^5^6
    end
    hash_value
  end
end
