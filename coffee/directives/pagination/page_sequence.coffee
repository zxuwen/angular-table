class PageSequence
  constructor: (@lowerBound = 0, @upperBound = 1, start = 0, @length = 1) ->
    throw "sequence is too long" if @length > (@upperBound - @lowerBound)
    @data = @generate(start)

  generate: (start) ->
    if start > (@upperBound - @length)
      start = @upperBound - @length
    else if start < @lowerBound
      start = @lowerBound
    x for x in [start..(parseInt(start) + parseInt(@length) - 1)]

  resetParameters: (lowerBound, upperBound, length) ->
    @lowerBound = lowerBound
    @upperBound = upperBound
    @length = length
    throw "sequence is too long" if @length > (@upperBound - @lowerBound)
    @data = @generate(@data[0])

  relocate: (distance) ->
    new_start = @data[0] + distance
    @data = @generate(new_start, new_start + @length)

  realignGreedy: (page) ->
    if page < @data[0]
      new_start = page
      @data = @generate(new_start)
    else if page > @data[@length - 1]
      new_start = page - (@length - 1)
      @data = @generate(new_start)

  realignGenerous: (page) ->
