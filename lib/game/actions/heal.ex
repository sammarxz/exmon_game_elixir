defmodule ExMon.Game.Actions.Heal do
  alias ExMon.Game
  alias ExMon.Game.Status

  @heal_value 18..25

  def heal_life(player) do
    heal_amount = Enum.random(@heal_value)

    player
    |> Game.fetch_player()
    |> Map.get(:life)
    |> calculate_total_life(heal_amount)
    |> update_player_life(player)
    |> update_game(player, heal_amount)
  end

  defp calculate_total_life(life, heal_amount), do: min(life + heal_amount, 100)

  defp update_player_life(life, player) do
    player
    |> Game.fetch_player()
    |> Map.put(:life, life)
  end

  defp update_game(player_data, player, heal_amount) do
    Game.info()
    |> Map.put(player, player_data)
    |> Game.update()

    Status.print_move_message(player, :heal, heal_amount)
  end
end
