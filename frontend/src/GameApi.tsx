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

export function createGame(): Promise<GameHeader[]> {
  return fetch('http://localhost:5173/api/games', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    }
  }).then((response) => {
    if (!response.ok) {
      throw new Error(`Failed to fetch games: ${response.status} ${response.statusText}`)
    }

    return response.json()
  })
}

export function listGames(): Promise<GameHeader[]> {
  return fetch('http://localhost:5173/api/games').then((response) => {
    if (!response.ok) {
      throw new Error(`Failed to fetch games: ${response.status} ${response.statusText}`)
    }

    return response.json()
  })
}

export function getGame(id: string): Promise<Game> {
  return fetch(`http://localhost:5173/api/games/${id}`).then((response) => {
    if (!response.ok) {
      throw new Error(`Failed to fetch game: ${response.status} ${response.statusText}`)
    }

    return response.json()
  })
}

export function makeMove(id: string, move: Move): Promise<Game> {
  return fetch(`http://localhost:5173/api/games/${id}/move`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from: to_coord(move.from),
      to: to_coord(move.to)
    }),
  }).then((response) => {
    if (!response.ok) {
      throw new Error(`Failed to fetch game: ${response.status} ${response.statusText}`)
    }

    return response.json()
  })
}

function to_coord(pos: string): string {
  const coords = pos.split('-')
  return `${to_file(coords[0])}${to_rank(coords[1])}`
}

function to_rank(n: string): string {
  if (n === '0') {
    return "1"
  }
  if (n === '1') {
    return "2"
  }
  if (n === '2') {
    return "3"
  }
  if (n === '3') {
    return "4"
  }
  if (n === '4') {
    return "5"
  }
  if (n === '5') {
    return "6"
  }
  if (n === '6') {
    return "7"
  }
  if (n === '7') {
    return "8"
  }
  return ""
}

function to_file(n: string): string {
  if (n === '0') {
    return "a"
  }

  if (n === '1') {
    return "b"
  }

  if (n === '2') {
    return "c"
  }

  if (n === '3') {
    return "d"
  }

  if (n === '4') {
    return "e"
  }

  if (n === '5') {
    return "f"
  }

  if (n === '6') {
    return "g"
  }

  if (n === '7') {
    return "h"
  }

  return ""
}