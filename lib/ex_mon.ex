defmodule ExMon do
  alias ExMon.{Game, Player, Status}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Ash"

  def start_game(player) do
    player
    |> Game.start(create_player(@computer_name))

    Status.print_round_message()
  end

  def create_player(name) do
    Player.build(name, :kick, :punch, :heal)
  end

  def make_move(move) do
    move
    |> Actions.fetch_move
  end
end
