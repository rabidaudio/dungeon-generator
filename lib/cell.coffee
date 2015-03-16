DIRECTIONS = ['north', 'south', 'east', 'west']
TYPES = ['empty', 'wall', 'door']

module.exports = class Cell
  constructor: (@directions={}, @isCorridor=false) ->
    @directions[direction] or= 'empty' for direction in DIRECTIONS

  isDeadEnd: -> @wallCount() is 3

  wallCount: -> 
    walls = 0
    (walls++ if type is 'wall') for key, type of @directions
    walls

  deadEndDirection: ->
    return false unless @isDeadEnd()

    # return 'north' if @directions['north'] is 'empty'
    # return 'south' if @directions['south'] is 'empty'
    # return 'east' if @directions['east'] is 'empty'
    # return 'west' if @directions['west'] is 'empty'