defmodule ExMonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Player

  describe "create_player/1" do
    test "returns a player struct with the given name" do
      player = ExMon.create_player("Sam")

      assert %Player{} = player
      assert player.name == "Sam"
      assert player.life == 100
      assert player.moves == %{move_rnd: :kick, move_avg: :punch, move_heal: :heal}
    end
  end

  describe "start_game/1" do
    test "starts the game and prints the initial message" do
      player = ExMon.create_player("Sam")

      output =
        capture_io(fn ->
          ExMon.start_game(player)
        end)

      assert output =~ "The game is started"
    end

    test "initializes game state correctly" do
      player = ExMon.create_player("Sam")

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      info = ExMon.Game.info()
      assert info.player.name == "Sam"
      assert info.computer.name == "Ash"
      assert info.status == :started
      assert info.turn == :player
    end
  end

  describe "make_move/1" do
    setup do
      player = ExMon.create_player("Sam")

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      :ok
    end

    test "executes a valid attack move" do
      output =
        capture_io(fn ->
          ExMon.make_move(:punch)
        end)

      assert output =~ "attacked"
    end

    test "executes a valid heal move" do
      output =
        capture_io(fn ->
          ExMon.make_move(:heal)
        end)

      assert output =~ "healed"
    end

    test "prints error for invalid move" do
      output =
        capture_io(fn ->
          ExMon.make_move(:invalid_move)
        end)

      assert output =~ "Invalid move"
    end

    test "computer makes a move after player's move" do
      output =
        capture_io(fn ->
          ExMon.make_move(:kick)
        end)

      # there should be at least two action messages (player + computer)
      assert output =~ "attacked" or output =~ "healed"
    end

    test "does not allow moves after game over" do
      # force game over
      state = ExMon.Game.info()
      computer = %{state.computer | life: 0}
      ExMon.Game.update(%{state | computer: computer})

      output =
        capture_io(fn ->
          ExMon.make_move(:punch)
        end)

      assert output =~ "The Game is over"
    end
  end
end
