DIRECTIONS = ['north', 'south', 'east', 'west']
TYPES = ['empty', 'wall', 'door']

module.exports = class Cell
  constructor: (@directions={}) ->
    @directions[direction] or= 'empty' for direction in DIRECTIONS

  isDeadEnd: -> @wallCount() is 3

  wallCount: -> 
    walls = 0
    (walls++ if type is 'wall') for key, type of @directions
    walls

  deadEndDirection: ->
    return false unless @isDeadEnd()
    (dir for type in (types for dir,types of @directions) when type is 'empty')[0]