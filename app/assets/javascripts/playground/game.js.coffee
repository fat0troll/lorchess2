board = undefined
game = new Chess()
statusEl = $('#status')
fenEl = $('#fen')
pgnEl = $('#pgn')

timer = ->
  status = $('#status')
  black =
    minutes: 15
    seconds: 0
  white =
    minutes: 15
    seconds: 0
  @current_player = true
  start = ->
    if (current_player)
      @countdown = setInterval(->
        @minus @white, 1000)
    else
      @countdown = setInterval(->
        @minus @black, 1000)
  minus = (time) ->
    if time.seconds is 0
      time.seconds = 59
      time.minutes = time.minutes - 1
    else
      time.seconds = time.seconds - 1
  @status = time.minutes + ':' + time.seconds
  change = ->
    clearInterval(@countdown)
    if @current_player is false
      @current_player = true
    else
      @current_player = false

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

# update the board position after the piece snap
# for castling, en passant, pawn promotion
onSnapEnd = ->
  board.position(game.fen())
  alert 'snapped'
  timer.change()
  timer.start()

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
  fenEl.html(game.fen())
  pgnEl.html(game.pgn())


cfg =
  draggable: true
  position: 'start'
  onDragStart: onDragStart
  onDrop: onDrop
  onSnapEnd: onSnapEnd
  pieceTheme: '/assets/playground/{piece}.png'

board = new ChessBoard('board', cfg)

updateStatus()
timer.start()