###
An enum is just an array of strings which also sets the values as all-caps parameters.
This allows for both for-each loops and named keys.

For example:
  e = new Enum 'one', 'two'
  e.ONE # => 'one'
  e.TWO # => 'two'
  console.log i for i in e #=> 'one', 'two'
###
module.exports = class Enum extends Array
  constructor: ->
    @push arguments...
    for field in @
      @[field.toUpperCase()] = field
