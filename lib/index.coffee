
Dungeon = require './dungeon'

generate = (@width=25, @height=25, @zigzagyness=30, @sparseness=70, @undeadendyness=50, @seed=null) ->
  dungeon = new Dungeon @width, @height, seed

  dungeon.createDenseMaze()
  dungeon.parsifyMaze()
  dungeon.removeDeadEnds()
  dungeon.generateRooms()
  dungeon.addDoors()

  return dungeon


generate.DIRECTIONS = require './directions'
generate.TYPES = require './types'
module.exports = generate