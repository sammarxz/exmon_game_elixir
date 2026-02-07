defmodule ExMon do
  alias ExMon.{Game, Player, Status}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Ash"

  def start_game(player) do
    @computer_name
    |> create_player()
    |> Game.start(player)

    Status.print_round_message()
  end

  def create_player(name) do
    Player.build(name, :kick, :punch, :heal)
  end

  def make_move(move) do
    move
    |> Actions.fetch_move
    |> do_move()
  end

  defp do_move({:error, move}), do: Status.print_wrong_move_message(move)
  defp do_move({:ok, move}) do
    case move do
      :move_heal -> "heal"
      move -> Actions.attack(move)
    end
  end
end
