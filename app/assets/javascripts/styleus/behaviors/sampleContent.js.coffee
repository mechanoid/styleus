namespace 'styleus.sampleContent', (exports) ->
  # TODO: replace all sample graphics with SVG
  class Shape
    constructor: ->
      @view = $('<div></div>')

    withClass: (classAttribute) =>
      @view.addClass(classAttribute)
      this

    render: => @view


  class Diagonal extends Shape
    constructor: (@width, @height, @direction) ->
      super()
      @view.addClass('diagonal')
      console.log(@height)

    expand: () =>
      @expandWidth()
      @rotate()
      @correctXPosition()

    expandWidth: =>
      @diagonalLength = Math.sqrt(Math.pow(@width, 2) + Math.pow(@height, 2))
      @view.width(@diagonalLength)


    # ##########################################################
    #   ______                                                 #
    #  |\    | We compute angular Beta here, in an orthogonal  #
    #  | \   | rectangular. So we solve tan(B) = a/b with      #
    # a|  \c | Angular B = atan(a/b).                          #
    #  |   \ |                                                 #
    #  |___B\| We multiply wit (180/PI) to get degrees.        #
    #     b                                                    #
    # ##########################################################
    computeRotationAngle: ->
      @angular_rad = Math.atan(@height / @width)
      @angular_deg = (180 / Math.PI) * @angular_rad

    rotate: =>
      @computeRotationAngle()
      rotation_angle = @angular_deg
      rotation_angle = 360 - rotation_angle if @direction is 'inverted'
      rotation = "rotate(#{rotation_angle}deg)"
      for platform in ['', '-webkit-', '-moz-', '-o-', '-ms-']
        @view.css("#{platform}transform", rotation)

    # because the rotation center is based on the width of an
    # element, we have to adjust the x-position dependent to
    # the with of the element, we placed the diagonals in.
    # !! We assume here relative positioning for diagonals. !!
    correctXPosition: ->
      offset = (@diagonalLength - @width) / 2
      @view.css('left', -offset)

  class SampleBox
    constructor: (@view) ->
      @expand()
      @addDiagonals() if @view.data('diagonals')

    expand: ->
      console.log @boxWidth, @boxHeight
      @boxWidth = @view.data('width') ? @view.innerWidth()
      @boxHeight = @view.data('height') ? @view.innerHeight()
      @view.css('width', @boxWidth)
      @view.css('height', @boxHeight)


    addDiagonals: =>
      diagonals = [new Diagonal(@boxWidth, @boxHeight), new Diagonal(@boxWidth, @boxHeight, 'inverted')]
      diagonal.expand() and @view.append(diagonal.render()) for diagonal in diagonals


  exports.install = (root) ->
    $root = $(root or document)
    boxes = $root.find('.styleus_sample.box')
    new SampleBox($(box)) for box in boxes


