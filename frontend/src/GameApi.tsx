export type GameHeader = {
  id: number
}

export type Game = {
  board: string[][]
}

export type Move = {
  from: string
  to: string
}

export function listGames(): Promise<GameHeader[]> {
  return fetch('http://localhost:5173/api/games').then((response) => {
    if (!response.ok) {
      throw new Error(`Failed to fetch games: ${response.status} ${response.statusText}`)
    }

    return response.json()
  })
}

export function getGame(id: number): Promise<Game> {
  return fetch(`http://localhost:5173/api/games/${id}`).then((response) => {
    if (!response.ok) {
      throw new Error(`Failed to fetch game: ${response.status} ${response.statusText}`)
    }

    return response.json()
  })
}

export function makeMove(id: number, move: Move): Promise<Game> {
  return fetch(`http://localhost:5173/api/games/${id}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(move),
  }).then((response) => {
    if (!response.ok) {
      throw new Error(`Failed to fetch game: ${response.status} ${response.statusText}`)
    }

    return response.json()
  })
}