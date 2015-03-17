DIRECTONS = require './directions'

module.exports = class Cell

  constructor: (d={}, @corridor=false) ->
    for direction in DIRECTONS
      this[direction] = d[direction] or 'empty' 

  isDeadEnd: -> @wallCount() is 3

  wallCount: -> 
    walls = 0
    (walls++ if this[d] is 'wall') for d in DIRECTONS
    walls

  doorCount: ->
    doors = 0
    (doors++ if this[d] is 'door') for d in DIRECTONS
    doors

  isEmpty: -> @wallCount()+@doorCount() is 0

  deadEndDirection: ->
    return false unless @isDeadEnd()
    for d in DIRECTONS
      return d if this[d] is 'empty'

  set: (direction, type) -> this[direction] = type if direction in DIRECTONS

  update: (d) ->
    for direction in DIRECTONS
      this[direction] = d[direction] if d[direction]?

  # isCorridor: -> @corridor