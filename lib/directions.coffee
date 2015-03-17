
DIRECTIONS = ['north', 'south', 'east', 'west']

DIRECTIONS.NORTH = 'north'
DIRECTIONS.SOUTH = 'south'
DIRECTIONS.EAST = 'east'
DIRECTIONS.WEST = 'west'

DIRECTIONS.opposite = (dir) ->
  switch dir
    when DIRECTIONS.NORTH then return DIRECTIONS.SOUTH
    when DIRECTIONS.SOUTH then return DIRECTIONS.NORTH
    when DIRECTIONS.EAST  then return DIRECTIONS.WEST
    when DIRECTIONS.WEST  then return DIRECTIONS.EAST
    else throw "Invalid direction #{dir}"

module.exports = DIRECTIONS