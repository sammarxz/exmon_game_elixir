defmodule ExMon do
  alias ExMon.{Game, Player, Status}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Ash"
  @computer_moves [:move_avg, :move_rnd, :move_heal]

  def start_game(player) do
    @computer_name
    |> create_player()
    |> Game.start(player)

    Status.print_round_message(Game.info())
  end

  @spec create_player(any()) :: %ExMon.Player{
          life: 100,
          moves: %{move_avg: any(), move_heal: any(), move_rnd: any()},
          name: any()
        }
  def create_player(name) do
    Player.build(name, :kick, :punch, :heal)
  end

  def make_move(move) do
    move
    |> Actions.fetch_move
    |> do_move()

    computer_move(Game.info())
  end

  defp do_move({:error, move}), do: Status.print_wrong_move_message(move)
  defp do_move({:ok, move}) do
    case move do
      :move_heal -> Actions.heal()
      move -> Actions.attack(move)
    end

    Status.print_round_message(Game.info())
  end

  defp computer_move(%{turn: :computer, status: :continue}) do
    move = {:ok, Enum.random(@computer_moves)}
    do_move(move)
  end
  defp computer_move(_), do: :ok
end
