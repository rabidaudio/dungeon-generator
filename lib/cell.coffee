DIRECTIONS = ['north', 'south', 'east', 'west']
TYPES = ['empty', 'wall', 'door']

module.exports = class Cell
  constructor: (@directions={}, @isCorridor=false) ->
    @directions[direction] or= 'empty' for direction in DIRECTIONS

  isDeadEnd: -> @wallCount() is 3

  wallCount: -> 
    walls = 0
    for key, type of @directions
      walls++ if type is 'wall'
    walls

  deadEndDirection: ->
    return false unless @isDeadEnd()
    direction for direction of DIRECTIONS when @directions[direction] is not 'empty'