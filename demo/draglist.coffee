KISSY.add "widget/draglist", (S,DOM,Node,Event,DragSwitch)->

  $ = S.all

  defaultConfig =
    enableScrollView  : true
    enableDragSwitch  : true
    enableTapHold     : true
    dragSwitchConfig:
      j : 0

  class DragList

    constructor: (@wrapperEl, @config)->
      @config = S.merge defaultConfig, @config

    init: ->
      @initScrollView if @config.enableScrollView
      @initDragSwitch if @config.enableDragSwitch
      @initTapHold    if @config.enableTapHold

    initScrollView: ->

    initDragSwitch: ->

    initTapHold: ->





,
  requires: ["dom", "node", "event", "widget/dragswitch"]