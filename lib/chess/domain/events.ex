defmodule Chess.Domain.Events do

  defmodule GameCreated do
    @derive {Jason.Encoder, only: [:id]}
    defstruct [:id]
  end

  defmodule MoveMade do
    @derive {Jason.Encoder, only: [:id, :from, :to, :player]}
    defstruct [:id, :from, :to, :player]
  end
end

