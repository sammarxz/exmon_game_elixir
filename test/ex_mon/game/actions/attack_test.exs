defmodule ExMon.Game.Actions.AttackTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions.Attack

  setup do
    computer = Player.build("Ash", :kick, :punch, :heal)
    player = Player.build("Sam", :kick, :punch, :heal)
    Game.start(computer, player)

    :ok
  end

  describe "attack_opponent/2" do
    test "deals damage to the computer with move_avg (18..25)" do
      capture_io(fn ->
        Attack.attack_opponent(:computer, :move_avg)
      end)

      computer = Game.fetch_player(:computer)
      damage = 100 - computer.life

      assert damage >= 18
      assert damage <= 25
    end

    test "deals damage to the computer with move_rnd (10..35)" do
      capture_io(fn ->
        Attack.attack_opponent(:computer, :move_rnd)
      end)

      computer = Game.fetch_player(:computer)
      damage = 100 - computer.life

      assert damage >= 10
      assert damage <= 35
    end

    test "deals damage to the player" do
      capture_io(fn ->
        Attack.attack_opponent(:player, :move_avg)
      end)

      player = Game.fetch_player(:player)
      assert player.life < 100
    end

    test "life does not go below 0" do
      # reduce computer life to near 0
      state = Game.info()
      computer = %{state.computer | life: 5}
      Game.update(%{state | computer: computer})

      capture_io(fn ->
        Attack.attack_opponent(:computer, :move_avg)
      end)

      computer = Game.fetch_player(:computer)
      assert computer.life == 0
    end

    test "prints attack message for computer target" do
      output =
        capture_io(fn ->
          Attack.attack_opponent(:computer, :move_avg)
        end)

      assert output =~ "Player attacked the computer"
    end

    test "prints attack message for player target" do
      output =
        capture_io(fn ->
          Attack.attack_opponent(:player, :move_avg)
        end)

      assert output =~ "Computer attacked the player"
    end

    test "updates game state after attack" do
      capture_io(fn ->
        Attack.attack_opponent(:computer, :move_avg)
      end)

      info = Game.info()
      assert info.status in [:continue, :game_over]
    end
  end
end
