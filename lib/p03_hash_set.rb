require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    self[key] << key
    @count+=1
    resize! if @count > num_buckets
  end

  def include?(key)
    self[key].include?(key)
  end

  def remove(key)
    self[key].delete(key)
    @count -=1
  end

  private

  def [](key)
    @store[key.hash % num_buckets]
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end

  def resize!
    arr = @store
    @store = Array.new(num_buckets * 2) {Array.new}
    @count = 0
    arr.each do |bucket|
      bucket.each do |el|
        insert(el)
      end
    end
  end
end
