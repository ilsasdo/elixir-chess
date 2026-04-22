import {useEffect, useState} from 'react'
import {BrowserRouter, Link, Route, Routes, useParams} from 'react-router-dom'
import './App.css'
import {type Game, getGame, listGames, makeMove} from './GameApi'

type GameHeader = {
  id: number
}

function Square(props: { cell: string, rowIndex: number, cellIndex: number, isSelected: boolean, onClick: () => void }) {
  return <div
      onClick={props.onClick}
      key={`${props.rowIndex}-${props.cellIndex}`}
      style={{borderColor: props.isSelected ? 'red' : 'black'}}
      className="cell">
    {props.cell === '' ? '\u00A0' : props.cell}
  </div>;
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
      console.log(
          `Making move from ${from} to ${to}`,
      )
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
    if (from === '') {
      setFrom(`${cellIndex}-${rowIndex}`)
      return
    }
    if (from === `${cellIndex}-${rowIndex}`) {
      setFrom('')
      return
    }
    if (to === '') {
      setTo(`${cellIndex}-${rowIndex}`)
      return
    }
  }

  return (
      <div>
        <h1>Chess board {gameId}</h1>
        <div style={{padding: '50px'}}>
          <div className="board-header">
            <div>a</div>
            <div>b</div>
            <div>c</div>
            <div>d</div>
            <div>e</div>
            <div>f</div>
            <div>g</div>
            <div>h</div>
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
                        onClick={() => handleCellClick(rowIndex, cellIndex)}/>
                )),
            )}
          </div>
        </div>
        <div className="board-header">
          <div>a</div>
          <div>b</div>
          <div>c</div>
          <div>d</div>
          <div>e</div>
          <div>f</div>
          <div>g</div>
          <div>h</div>
        </div>
      </div>
  )
}

function GameList() {
  const [games, setGames] = useState<GameHeader[]>([])

  useEffect(() => {
    listGames()
    .then((data) => {
      setGames(data as GameHeader[])
    })
    .catch((error) => {
      console.error(error)
    })
  }, [])

  return (
      <>
        <h1>Available Games</h1>
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