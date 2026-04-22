import { useEffect, useState } from 'react'
import './App.css'
import { listGames, type GameHeader } from './GameApi'

function ChessBoard() {
  return (
    <div>

    </div>
  )
}

function App() {
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
          <li key={game.id}>Game {game.id}</li>
        ))}
      </ul>
      <ChessBoard />
    </>
  )
}

export default App
