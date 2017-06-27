require_relative 'p02_hashing'
require_relative 'p04_linked_list'


# Now you have a HashMap that uses LL for each bucket. Each node in the
# LL contains the key-value mapping you want.
# The only small downside is the small possibility of having two
# keys return a modulo to the same bucket, in which case would create
# a LL that's longer than one. But it's still really fast to traverse
# the LL, on average it evens out to be constant time for set/getting
# an element out of a HashMap.

class HashMap
  include Enumerable
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    return false if self[key].nil?
    true
  end

  def set(key, val)
    if @store[key.hash % num_buckets].include?(key)
      @store[key.hash % num_buckets].remove(key)
      @store[key.hash % num_buckets].append(key, val)
    else
      @store[key.hash % num_buckets].append(key, val)
      @count +=1
    end
    resize! if @count > num_buckets
  end

  def get(key)
    #returns a value, not key
    @store[key.hash % num_buckets].get(key)
  end

  def delete(key)
    if include?(key)
      @store[key.hash % num_buckets].remove(key)
      @count -=1
    end
  end

  def each(&prc)
    @store.each do |linked_list|
      linked_list.each do |link|
        prc.call(link.key, link.val)
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end
  private

  alias_method :[], :get
  alias_method :[]=, :set

  def num_buckets
    @store.length
  end

  def resize!
    arr = @store
    @store = Array.new(num_buckets * 2) {LinkedList.new}
    @count = 0
    arr.each do |linked_list|
      linked_list.each do |link|
        self[link.key] = link.val
      end
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
  end
end
