KISSY.add "widget/dragswitch", (S, Node, Event, UA, SSlog) ->

  $ = KISSY.all
  defaultConfig =
    distance: 6
    angle: Math.PI / 6
    checkvalid: null
    inertiaMove: false
    disable    : false
    binds: [null, null, null, null,
            moveEls: []
            maxDistance: 99999
            validDistance: null
            passCallback: null
            failCallback: null
            checkvalid: null
    ]

  # 最后一个只是例子，其实完全没用处，顺序按 up, right, down, left
  class DragSwitch

    constructor: (@el, @config)->
      S.mix @, S.EventTarget
      @init()

    init: ->
      @config = S.merge(defaultConfig, @config)
      @disable = @config.disable
      @isSelector = true if typeof @el is "string"
      @el = $(@el) if !@isSelector
      @tanAngel = Math.tan(@config.angle)
      @effectEls = []
      for item in @config.binds
        continue if !item
        if !item.moveEls.join("")
          item.moveEls = [@el]
          @effectEls.push $(@el)
        else
          @effectEls.push $(el) for el in item.moveEls
      @bindEvents()

    bindEvents: ->
      if @isSelector
        $('body').delegate "touchstart", @el, (ev) => @touchStart(ev)
        $('body').delegate "touchmove", @el, (ev) => @touchMove(ev)
        $('body').delegate "touchend", @el, (ev) => @touchEnd(ev)
      else
        @el.on "touchstart", (ev) => @touchStart(ev)
        @el.on "touchmove", (ev) => @touchMove(ev)
        @el.on "touchend", (ev) => @touchEnd(ev)

    touchStart: (ev)->
      return if @disable
      @enabled = if @config.checkvalid then @config.checkvalid() else true # 外部检查
      return if !@enabled
      ev.halt()
      ev = ev.originalEvent
      @istouchStart = true
      @isSendStart = false
      @eventType = null
      @key = null
      @startPoint = [ev.touches[0].pageX, ev.touches[0].pageY]
      @lastPoint = @startPoint.slice()
      @yesterPoint = @lastPoint.slice()
      @saveMatrixState()

    touchMove: (e)->
      return if !@istouchStart
      ev = e.originalEvent
      point = [ev.touches[0].pageX, ev.touches[0].pageY]
      oPoint = @startPoint
      angleDelta = Math.abs((oPoint[1] - point[1]) / (point[0] - oPoint[0])) # 这是水平方向的
      distance = [oPoint[0] - point[0], oPoint[1] - point[1]]
      maxDistance = Math.max(Math.abs(distance[0]), Math.abs(distance[1]))
      if not @isSendStart and angleDelta > @tanAngel and 1 / angleDelta > @tanAngel
        @istouchStart = false
        return
      else if not @eventType and maxDistance >= @config.distance
        if angleDelta <= @tanAngel #水平
          @eventType = (if distance[0] > 0 then "dragRight" else "dragLeft")
        else if 1 / angleDelta <= @tanAngel
          @eventType = (if distance[1] > 0 then "dragUp" else "dragDown")
        else
          @eventType = null
        @key = (if @eventType is "dragUp" then 0 else (if @eventType is "dragRight" then 1 else (if @eventType is "dragDown" then 2 else (if @eventType is "dragLeft" then 3 else null))))
        @obbKey = 1 - @key % 2
        @effectBind = @config.binds[@key]
        @moveEls = @effectBind.moveEls
        @enabled = if @effectBind.checkvalid then @effectBind.checkvalid() else true # 内部检查
        # 记录初始时间
        @startTime = new Date
        $("body").addClass "dragswitch-dragging"
      return if !@eventType or !@enabled
      if !@isSendStart
        @fire @eventType + "Start", S.mix(e, self: @)
        @isSendStart = true
      @fire @eventType, S.mix(e, self: @)
      if !e.isDefaultPrevented()
        @move point
      @yesterPoint = @lastPoint.slice()
      @yesterTime = new Date(@lastTime)
      @lastPoint = point.slice()
      @lastTime = new Date

    touchEnd: (e)->
      $("body").removeClass "dragswitch-dragging"
      if @istouchStart and @isSendStart
        if !@config.inertiaMove
          @touchEndHandler(e)
        else
          v = (@yesterPoint[@obbKey] - @lastPoint[@obbKey]) / (@yesterTime - @lastTime)

      @istouchStart = false
      @isSendStart = false

    touchEndHandler: (e)->
      @fire @eventType + "End", S.mix(e, self: @)
      obj = @effectBind
      if Math.abs(@distance) >= obj.validDistance
        if obj.passCallback
          obj.passCallback.call e.target, S.mix(e, self: @)
      else
        # 复原
        @restoreMatrixState()

    saveMatrixState: ->
      for el in @effectEls
        el.matrixState = @getMatrix el

    getMatrix: (el)->
      $(el).css("-webkit-transform") or $(el).css("-o-transform") or $(el).css("transform")

    setMatrix: (el, matrix)->
      $(el).css
        "transform"         : matrix
        "-webkit-transform" : matrix
        "-ms-transform"     : matrix
        "-o-transform"      : matrix

    restoreMatrixState: ->
      for el in @effectEls
        @setMatrix el, el.matrixState

    move: (endPoint)->
      key = @key
      startPoint = @startPoint
      lastPoint = @lastPoint
      rawDistance = @distance = (if key % 2 is 0 then endPoint[1] - startPoint[1] else endPoint[0] - startPoint[0])
      distance = (if key % 2 is 0 then endPoint[1] - lastPoint[1] else endPoint[0] - lastPoint[0])
      return if !@effectBind or @effectBind.maxDistance < Math.abs(rawDistance)
      for el in @moveEls
        currentMatrix = @getMatrix el
        @setMatrix el, @translate(currentMatrix, distance, key % 2)

    translate: (currentMatrix, distance, hori)->
      matrix = currentMatrix.match /[0-9\.\-]+/g
      matrix = [1,0,0,1,0,0] if !matrix
      matrix.forEach (item, key)-> matrix[key] = parseFloat(item)
      matrix[4] += distance * hori
      matrix[5] += distance * (1 - hori)
      return "matrix(" + matrix.join(',') + ")"
#      if UA.webkit
#        (new WebKitCSSMatrix(currentMatrix)).translate(distance * hori, distance * (1 - hori)).toString()


,
  requires: ["node", "event", "ua", "widget/sslog"]