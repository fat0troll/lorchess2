board = undefined
game = new Chess()
statusEl = $('#status')
fenEl = $('#fen')
pgnEl = $('#pgn')

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