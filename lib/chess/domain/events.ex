defmodule Chess.Domain.Events do

  defmodule GameCreated do
    @derive {Jason.Encoder, only: [:id, :fen]}
    defstruct [:id, :fen]
  end

  defmodule MoveMade do
    @derive {Jason.Encoder, only: [:id, :from, :to, :player, :fen]}
    defstruct [:id, :from, :to, :player, :fen]
  end
end

