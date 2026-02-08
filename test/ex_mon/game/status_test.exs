defmodule ExMon.Game.StatusTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Game.Status

  describe "print_round_message/1" do
    test "prints started message when status is :started" do
      info = %{status: :started, player: "Sam", computer: "Ash"}

      output =
        capture_io(fn ->
          Status.print_round_message(info)
        end)

      assert output =~ "The game is started"
    end

    test "prints turn message when status is :continue" do
      info = %{status: :continue, turn: :player, player: "Sam", computer: "Ash"}

      output =
        capture_io(fn ->
          Status.print_round_message(info)
        end)

      assert output =~ "It's player turn"
    end

    test "prints computer turn message" do
      info = %{status: :continue, turn: :computer, player: "Sam", computer: "Ash"}

      output =
        capture_io(fn ->
          Status.print_round_message(info)
        end)

      assert output =~ "It's computer turn"
    end

    test "prints game over message when status is :game_over" do
      info = %{status: :game_over, player: "Sam", computer: "Ash"}

      output =
        capture_io(fn ->
          Status.print_round_message(info)
        end)

      assert output =~ "The Game is over"
    end
  end

  describe "print_wrong_move_message/1" do
    test "prints the invalid move name" do
      output =
        capture_io(fn ->
          Status.print_wrong_move_message(:fireball)
        end)

      assert output =~ "Invalid move: fireball"
    end
  end

  describe "print_move_message/3" do
    test "prints attack message when attacking computer" do
      output =
        capture_io(fn ->
          Status.print_move_message(:computer, :attack, 20)
        end)

      assert output =~ "Player attacked the computer dealing: 20 damage"
    end

    test "prints attack message when attacking player" do
      output =
        capture_io(fn ->
          Status.print_move_message(:player, :attack, 15)
        end)

      assert output =~ "Computer attacked the player dealing: 15 damage"
    end

    test "prints heal message" do
      output =
        capture_io(fn ->
          Status.print_move_message(:player, :heal, 22)
        end)

      assert output =~ "player healed itself recovering 22 life points"
    end
  end
end
