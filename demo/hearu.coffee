KISSY.use "dom, node, anim, event, widget/dragswitch, widget/sslog", (S, DOM, Node, Anim, Event, HoriDrag, SSlog) ->
  $ = KISSY.all
  $("body").addClass "EntryList"

  # 初始化 UI
  new HoriDrag("#Main",
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

  new HoriDrag(".entry-item",
    binds: [
      null,
      null,
      null,
      {
      moveEls        : [] # 如果不为空，则只移动这里的元素
      maxDistance   : 40
      validDistance : 30
      passCallback  : (ev)->
#        $("#Main")[0].style.webkitTransform = ""
#        $("body")[0].className = "Menu"
      failCallback  : null
      checkvalid    : null    # 满足此条件时才可生效
      }
    ]
  )

