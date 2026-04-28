defmodule Chess.Domain.Commands do
  defmodule CreateGame do
    defstruct [:id]
  end

  defmodule MakeMove do
    defstruct [:id, :from, :to, :player]
  end

end
