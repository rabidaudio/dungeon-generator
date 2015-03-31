RandomJS = require 'random-js'

module.exports = class MersenneTwister

  constructor: (seed=null)->
    @engine = RandomJS.engines.mt19937()
    if seed? then @engine.seed(seed) else @engine.autoSeed()

  next: (min, max) ->
    if not max?
      max = min
      min = 0
    RandomJS.integer(min, max)(@engine)