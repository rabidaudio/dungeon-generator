
RandomJS = require 'random-js'


module.exports = class MersenneTwister
  engine = RandomJS.engines.mt19937()

  constructor: (seed=null)->
    if seed? then engine.seed(seed) else engine.autoSeed()

  next: (min, max) ->
    if not max?
      max = min
      min = 0
    RandomJS.integer(min, max)(engine)