###
  The purpose of this is to hide these magic strings behind variable names.
  It also allows us to use the `for x in...` pattern. 
###
TYPES = ['door', 'wall', 'empty']

TYPES.DOOR  = TYPES[0]
TYPES.WALL  = TYPES[1]
TYPES.EMPTY = TYPES[2]

module.exports = TYPES