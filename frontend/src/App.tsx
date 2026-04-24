import {useEffect, useState} from 'react'
import {BrowserRouter, Link, Route, Routes, useParams} from 'react-router-dom'
import './App.css'
import {type Game, createGame, getGame, listGames, makeMove} from './GameApi'

const PIECE_MAP: Record<string, string> = {
  'R': '♜', 'N': '♞', 'B': '♝', 'Q': '♛', 'K': '♚', 'P': '♟',
  'r': '♖', 'n': '♘', 'b': '♗', 'q': '♕', 'k': '♔', 'p': '♙',
}

type GameHeader = {
  id: number
}

function Square(props: { cell: string, rowIndex: number, cellIndex: number, isSelected: boolean, onClick: () => void }) {
  const isLight = (props.rowIndex + props.cellIndex) % 2 === 0
  const piece = PIECE_MAP[props.cell] || ''
  const isWhitePiece = piece && '♔♕♖♗♘♙'.includes(piece)

  return (
    <div
      onClick={props.onClick}
      className={`cell ${isLight ? 'cell-light' : 'cell-dark'} ${props.isSelected ? 'selected' : ''}`}>
      <span className={`piece ${isWhitePiece ? 'piece-white' : 'piece-black'}`}>
        {piece || '\u00A0'}
      </span>
    </div>
  )
}

function ChessBoard() {
  const {id} = useParams<{ id: string }>()
  const gameId: string = id!
  const [game, setGame] = useState<Game>({board: []});
  const [from, setFrom] = useState<string>('');
  const [to, setTo] = useState<string>('');

  useEffect(() => {
    getGame(gameId)
    .then((data) => {
      setGame(data as Game)
    })
    .catch((error) => {
      console.error(error)
    })
  }, [gameId])

  useEffect(() => {
    if (from !== '' && to !== '') {
      makeMove(gameId, {from: from, to: to})
      .then((data) => {
        setGame(data as Game)
        setFrom('')
        setTo('')
      })
      .catch((error) => {
        console.error(error)
      })
    }
  }, [from, to])

  const handleCellClick = (rowIndex: number, cellIndex: number) => {
    const key = `${cellIndex}-${rowIndex}`
    if (from === '') {
      setFrom(key)
      return
    }
    if (from === key) {
      setFrom('')
      return
    }
    if (to === '') {
      setTo(key)
      return
    }
  }

  return (
    <div>
      <h1 className="game-title">Chess Board <span>#{gameId}</span></h1>
      <div className="board-container">
        <div className="board-header">
          <div>a</div><div>b</div><div>c</div><div>d</div>
          <div>e</div><div>f</div><div>g</div><div>h</div>
        </div>
        <div className="board-wrapper">
          <div className="rank-labels">
            <div className="rank-label">8</div>
            <div className="rank-label">7</div>
            <div className="rank-label">6</div>
            <div className="rank-label">5</div>
            <div className="rank-label">4</div>
            <div className="rank-label">3</div>
            <div className="rank-label">2</div>
            <div className="rank-label">1</div>
          </div>
          <div className="board">
            {game.board.map((row, rowIndex) =>
              row.map((cell, cellIndex) => (
                <Square
                  key={`${cellIndex}-${rowIndex}`}
                  cell={cell}
                  rowIndex={rowIndex}
                  cellIndex={cellIndex}
                  isSelected={from === `${cellIndex}-${rowIndex}`}
                  onClick={() => handleCellClick(rowIndex, cellIndex)}
                />
              ))
            )}
          </div>
        </div>
        <div className="board-header">
          <div>a</div><div>b</div><div>c</div><div>d</div>
          <div>e</div><div>f</div><div>g</div><div>h</div>
        </div>
      </div>
    </div>
  )
}

function GameList() {
  const [games, setGames] = useState<GameHeader[]>([])
  const [refreshKey, setRefreshKey] = useState(0)

  useEffect(() => {
    listGames()
    .then((data) => {
      setGames(data as GameHeader[])
    })
    .catch((error) => {
      console.error(error)
    })
  }, [refreshKey])

  const handleCreateGame = () => {
    createGame()
    .then(() => {
      setRefreshKey((k) => k + 1)
    })
    .catch((error) => {
      console.error(error)
    })
  }

  return (
    <>
      <h1>Available Games</h1>
      <button onClick={handleCreateGame}>Create New Game</button>
      <ul>
        {games.map((game) => (
          <li key={game.id}>
            <Link to={`/games/${game.id}`}>Game {game.id}</Link>
          </li>
        ))}
      </ul>
    </>
  )
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<GameList/>}/>
        <Route path="/games/:id" element={<ChessBoard/>}/>
      </Routes>
    </BrowserRouter>
  )
}

export default App