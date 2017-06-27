require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

# LRUCache creates a Least Recently Used Cache of items.
# Max refers to how big this cache is.

# This implementation of a LRUCache uses a LL and a HashMap in conjunction.
# If we only had a LL, getting/setting/deleting would take O(n) time.
# Using a HashMap helps us do things in O(1) time.
#
# Each node in the LL contains a key and a value, while the HashMap only contains the key
# that maps to a specific node in the LL. Every time you retrieve a node
# from the LL, you have to update the LL structure to make the most recent used item
# the retrieved node. You also have to update the HashMap's connection to the LL.

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    #returns link if it exists
    link = @map[key]

    if link.nil?
      result = @prc.call(key)
      link = @store.append(key, result)
      @map[key] = link
      eject! if count > @max
    else
      update_link!(link)
    end
    link.val
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  # suggested helper method; insert an (un-cached) key

  def calc!(key)
    prc.call(key)
  end

  # suggested helper method; move a link to the end of the list
  def update_link!(link)
    key = link.key
    val = link.val
    @store.remove(key)
    link = @store.append(key,val)  #this is where you move the link to end of list
    @map[key] = link
  end

  def eject!
    p "ejected"
    key = @store.first.key
    @store.remove(key)
    @map.delete(key)
  end

end
