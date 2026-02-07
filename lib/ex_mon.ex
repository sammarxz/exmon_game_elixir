defmodule ExMon do
  alias ExMon.{Game, Player}

  @computer_name "Ash"

  def create_player(name, move_avg, move_rnd, move_heal) do
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  def start_game(player) do
   create_pc_player()
    |> Game.start(player)
  end

  defp create_pc_player do
    @computer_name
    |> create_player(:punch, :kick, :heal)
  end
end
