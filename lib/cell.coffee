DIRECTONS = require './directions'

module.exports = class Cell

  constructor: (d=null, @corridor=false) ->
    if d?
      for direction in DIRECTONS
        this[direction] = d[direction] or 'empty'
      @blank = false
    else
      @blank = true

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

  # set: (direction, type) -> this[direction] = type if direction in DIRECTONS

  notBlank: -> not @blank

  update: (d) ->
    for direction in DIRECTONS
      this[direction] = if d[direction]? then d[direction] else 'empty'
    @blank = false

  visit: -> @visited = true

  clearVisits: -> @visited = false