defmodule ExMon.Game.Actions.HealTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions.Heal

  setup do
    computer = Player.build("Ash", :kick, :punch, :heal)
    player = Player.build("Sam", :kick, :punch, :heal)
    Game.start(computer, player)

    :ok
  end

  describe "heal_life/1" do
    test "heals the player by 18..25 points" do
      # reduce player life first
      state = Game.info()
      player = %{state.player | life: 50}
      Game.update(%{state | player: player})

      capture_io(fn ->
        Heal.heal_life(:player)
      end)

      healed_player = Game.fetch_player(:player)
      heal_amount = healed_player.life - 50

      assert heal_amount >= 18
      assert heal_amount <= 25
    end

    test "heals the computer" do
      # reduce computer life first
      state = Game.info()
      computer = %{state.computer | life: 50}
      Game.update(%{state | computer: computer})

      capture_io(fn ->
        Heal.heal_life(:computer)
      end)

      healed_computer = Game.fetch_player(:computer)
      assert healed_computer.life > 50
    end

    test "life does not exceed 100" do
      # player at 90 life, heal of 18..25 would exceed 100
      state = Game.info()
      player = %{state.player | life: 90}
      Game.update(%{state | player: player})

      capture_io(fn ->
        Heal.heal_life(:player)
      end)

      healed_player = Game.fetch_player(:player)
      assert healed_player.life <= 100
    end

    test "prints heal message" do
      state = Game.info()
      player = %{state.player | life: 50}
      Game.update(%{state | player: player})

      output =
        capture_io(fn ->
          Heal.heal_life(:player)
        end)

      assert output =~ "healed itself"
    end

    test "updates game state after healing" do
      capture_io(fn ->
        Heal.heal_life(:player)
      end)

      info = Game.info()
      assert info.status in [:continue, :game_over]
    end
  end
end
