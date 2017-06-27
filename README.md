# Hash Map/LRU Cache

I created my own Hash Map in Ruby using a LinkedList and hashing algorithm. After creating the HashMap
I created a LRU Cache using the HashMap.

My goal with the Hash Map was to be able to insert, update, and delete key value pairs in O(1) time. Creating
an array of "buckets" helped me achieve this goal.


## Hashing Algorithm

Ruby's Fixnum hash method was used as the basis for my hashing algorithm. I could turn any array, string, and
hash into a unique key, and guarantee determinism when using the same input. I used the XOR operator to create my
unique hash values.

For an array, I used each element's unique position to generate a hash value. I used the same technique for Strings
and used "ord" to obtain the ASCII value. To create a key from a hash, I hashed the key and the value individually
to generate the hash value; doing so ensured that two identical hashes with different ordering returned the same
hash value.

```ruby
class Array
  def hash
    hash_value = 0
    self.each_with_index do |el,i|
      hash_value = hash_value^(el.hash+i)  #the hash_value is updated for each new element.
    end
    hash_value
  end
end
```


## HashMap

I used an array as my main hash structure. Each index of the array was a doubly
LinkedList that served as a "bucket". Using a LinkedList instead of an array as a bucket helped me store the data as a key-value pair in each node. Whenever I inserted a key-value pair into the hash structure, I used the hashing algorithm on the key and the modulo operation to tell me which bucket I needed to insert the key-value pair.

When the number of key-value pairs exceeded the size of the array, I would create a new
array that was double the size of the original array, and reinsert each key-value pair. By resizing the hash
structure, I amortized the "read, update, delete" operations to O(1).

```ruby
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
```

## LRU Cache

The LRU Cache has a specific size upon initialization. The order of the nodes in the LinkedList tells you how often
the item was used. The most recently used item would be at the end of the LinkedList, while the oldest item would be at the front of the LinkedList. Any time I used an item (i.e. retrieve an item), I would have to update the LinkedList ordering.

To ensure constant time complexity for getting, updating, and deleting items, I created a HashMap structure that mapped to a specific node in the LinkedList. Each key in the HashMap returned a node in the LinkedList that had the
same key value. The node's value is the actual data we want; the key is an arbitrary value and used only to help keep the time complexity O(1).  

```ruby
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
```
