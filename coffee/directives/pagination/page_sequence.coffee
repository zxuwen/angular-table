class PageSequence
  constructor: (@lower_bound = 0, @upper_bound = 1, start = 0, @length = 1) ->
    throw "sequence is too long" if @length > (@upper_bound - @lower_bound)
    @data = @generate(start)

  generate: (start) ->
    if start > (@upper_bound - @length)
      start = @upper_bound - @length
    else if start < @lower_bound
      start = @lower_bound
    x for x in [start..(parseInt(start) + parseInt(@length) - 1)]

  reset_parameters: (lower_bound, upper_bound, length) ->
    @lower_bound = lower_bound
    @upper_bound = upper_bound
    @length = length
    throw "sequence is too long" if @length > (@upper_bound - @lower_bound)
    @data = @generate(@data[0])

  relocate: (distance) ->
    new_start = @data[0] + distance
    @data = @generate(new_start, new_start + @length)

  realign_greedy: (page) ->
    if page < @data[0]
      new_start = page
      @data = @generate(new_start)
    else if page > @data[@length - 1]
      new_start = page - (@length - 1)
      @data = @generate(new_start)

  realign_generous: (page) ->
