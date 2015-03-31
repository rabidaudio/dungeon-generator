###
  The purpose of this is to hide these magic strings behind variable names.
  It also allows us to use the `for x in...` pattern. 
###
DIRECTIONS = ['north', 'south', 'east', 'west']

DIRECTIONS.NORTH = DIRECTIONS[0]
DIRECTIONS.SOUTH = DIRECTIONS[1]
DIRECTIONS.EAST  = DIRECTIONS[2]
DIRECTIONS.WEST  = DIRECTIONS[3]

DIRECTIONS.opposite = (dir) ->
  switch dir
    when DIRECTIONS.NORTH then return DIRECTIONS.SOUTH
    when DIRECTIONS.SOUTH then return DIRECTIONS.NORTH
    when DIRECTIONS.EAST  then return DIRECTIONS.WEST
    when DIRECTIONS.WEST  then return DIRECTIONS.EAST
    else throw "Invalid direction #{dir}"

module.exports = DIRECTIONS