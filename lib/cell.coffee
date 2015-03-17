# TYPES = ['empty', 'wall', 'door']

module.exports = class Cell

  constructor: (d={}, corridor=false) ->
    @edges = d or {}
    @edges[direction] or= 'empty' for direction in ['north', 'south', 'east', 'west']

  isDeadEnd: -> @wallCount() is 3

  wallCount: -> 
    walls = 0
    (walls++ if type is 'wall') for key, type of @edges
    walls

  isEmpty: -> @wallCount() is 0

  deadEndDirection: ->
    return false unless @isDeadEnd()
    (dir for type in (types for dir,types of @edges) when type is 'empty')[0]

  set: (direction, type) -> directions[direction] = type

  update: (d) ->
    for direction in ['north', 'south', 'east', 'west']
      @edges[direction] = d[direction] if d[direction]?


  setNorth: (type) -> @set 'north', type

  setSouth: (type) -> @set 'south', type

  setEast: (type) -> @set 'east', type

  setWest: (type) ->@set 'west', type