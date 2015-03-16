
directionTypes = require './directionTypes'
sideTypes = require './sideTypes'

module.exports = class Cell
  constructor: (@directions={}, @isCorridor=false) ->
    @directions[directionTypes.NORTH] or= sideTypes.EMPTY
    @directions[directionTypes.SOUTH] or= sideTypes.EMPTY
    @directions[directionTypes.EAST] or= sideTypes.EMPTY
    @directions[directionTypes.WEST] or= sideTypes.EMPTY


  isDeadEnd: -> @wallCount() is 3

  wallCount: -> 
    for direction in @directions
      walls += (s is sideTypes.WALL)
    # @directions.reduce (t,s) -> t + (s is sideTypes.WALL)
    walls

  deadEndDirection: ->
    return false unless @isDeadEnd()
    direction for direction of directionTypes when @directions[direction] is not sideTypes.EMPTY