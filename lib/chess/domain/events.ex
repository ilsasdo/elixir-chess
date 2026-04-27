defmodule Chess.Domain.Events.GameCreated do
  defstruct [:game_id, :fen_initial_state]
end
