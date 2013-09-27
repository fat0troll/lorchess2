board = undefined
game = new Chess()
statusEl = $('#status')

time = 20*60
fischer = 5

normalize = (value) ->
  seconds = value%60
  minutes = (value - seconds)/60
  if (value%60 < 10) 
    seconds = "0" + value%60
  return "<b>" + minutes + ":" + seconds + "</b>"

time_is_up = ->
  statusEl.html("Time is up")
  board.destroy()
  new_cfg = 
    draggable: false
    position: game.fen()
    pieceTheme: '/assets/playground/{piece}.png'
  board = new ChessBoard('board', new_cfg)

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

onDragStart = (source, piece, position, orientation) ->
  if (game.game_over() == true ||
    game.turn() == 'w' && piece.search(/^b/) != -1 ||
    game.turn() == 'b' && piece.search(/^w/) != -1)
      return false

onDrop = (source, target) ->
  # see if the move is legal
  move = game.move(
    from: source,
    to: target,
    promotion: 'q'
  )

  # illegal move
  if move == null
    return 'snapback'

  updateStatus()
  changeClock()

# update the board position after the piece snap
# for castling, en passant, pawn promotion
onSnapEnd = ->
  board.position(game.fen())

changeClock = ->
  if game.turn() == 'b'
    white.pause()
    black.start()
  else if game.turn() == 'w'
    black.pause()
    white.start()

updateStatus = ->
  status = ''

  moveColor = 'White'
  if game.turn() == 'b'
    moveColor = 'Black'

  # checkmate?
  if game.in_checkmate() == true
    status = 'Game over, ' + moveColor + ' is in checkmate.'

  # draw?
  else if game.in_draw() == true
    status = 'Game over, drawn position'

  # game still on
  else
    status = moveColor + ' to move'

    # check?
    if game.in_check() == true
      status += ', ' + moveColor + ' is in check'

  statusEl.html(status)

cfg =
  draggable: true
  position: 'start'
  onDragStart: onDragStart
  onDrop: onDrop
  onSnapEnd: onSnapEnd
  pieceTheme: '/assets/playground/{piece}.png'

board = new ChessBoard('board', cfg)

white = new Timer($('#white_clock'))
black = new Timer($('#black_clock'))

updateStatus()