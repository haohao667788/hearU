KISSY.use "dom, node, anim, event, widget/dragswitch, widget/sslog, widget/draglist", (S, DOM, Node, Anim, Event, DragSwitch, SSlog, DragList) ->
  $ = KISSY.all
  $("body").addClass "EntryList"

  # 初始化 UI
  new DragSwitch("#Main",
    binds: [
      null,
      {
        moveEls        : [] # 如果不为空，则只移动这里的元素
        maxDistance   : 200
        validDistance : 20 # 一般是 maxDistance/2
        passCallback  : ->
          $("#Main")[0].style.webkitTransform = ""
          $("body")[0].className = "Main"
        failCallback  : null
        checkvalid    : ->
          return $("body").hasClass "Menu"
      }
      null,
      {
        moveEls        : [] # 如果不为空，则只移动这里的元素
        maxDistance   : DOM.viewportWidth()
        validDistance : DOM.viewportWidth() / 2 # 一般是 maxDistance/2
        passCallback  : ->
          $("#Main")[0].style.webkitTransform = ""
          $("body")[0].className = "Menu"
        failCallback  : null
        checkvalid    : null    # 满足此条件时才可生效
      }
    ]
  )

  new DragSwitch(".entry-item",
    binds: [
      null,
      null,
      null,
      {
      moveEls        : [] # 如果不为空，则只移动这里的元素
      maxDistance   : 60
      validDistance : 30
      passCallback  : (ev)->
        $(ev.currentTarget).parent().addClass "entry-list-left"
        ev.currentTarget.style.webkitTransform = ""

#        $("#Main")[0].style.webkitTransform = ""
#        $("body")[0].className = "Menu"
      failCallback  : null
      checkvalid    : null    # 满足此条件时才可生效
      }
    ]
  )

  $('#EntryList').on "touchstart", ->
    $(".entry-list-item").removeClass "entry-list-left"
#
#  new DragList

