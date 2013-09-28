class Timer
  constructor : (@panel) ->
    @time = time
    @update()

  update : =>
    @panel.html(normalize(@time))

  start : =>
    @countdown = setInterval(@decrease, 1000)
    return

  decrease : =>
    @time = @time - 1
    @update()
    if (@time == 0)
      clearInterval(@countdown)
      time_is_up()
    return

  pause : =>
    clearInterval(@countdown)
    @time += fischer
    @update()
    return