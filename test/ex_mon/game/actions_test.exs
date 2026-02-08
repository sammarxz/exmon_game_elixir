defmodule ExMon.Game.ActionsTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions

  setup do
    computer = Player.build("Ash", :kick, :punch, :heal)
    player = Player.build("Sam", :kick, :punch, :heal)
    Game.start(computer, player)

    :ok
  end

  describe "fetch_move/1" do
    test "returns {:ok, :move_avg} for a valid average move" do
      assert {:ok, :move_avg} = Actions.fetch_move(:punch)
    end

    test "returns {:ok, :move_rnd} for a valid random move" do
      assert {:ok, :move_rnd} = Actions.fetch_move(:kick)
    end

    test "returns {:ok, :move_heal} for a valid heal move" do
      assert {:ok, :move_heal} = Actions.fetch_move(:heal)
    end

    test "returns {:error, move} for an invalid move" do
      assert {:error, :invalid} = Actions.fetch_move(:invalid)
    end
  end

  describe "attack/1" do
    test "reduces computer life when it is player's turn" do
      capture_io(fn ->
        Actions.attack(:move_avg)
      end)

      computer = Game.fetch_player(:computer)
      assert computer.life < 100
    end

    test "reduces player life when it is computer's turn" do
      # switch turn to computer
      state = Game.info()
      Game.update(state)

      capture_io(fn ->
        Actions.attack(:move_avg)
      end)

      player = Game.fetch_player(:player)
      assert player.life < 100
    end
  end

  describe "heal/0" do
    test "heals the player when it is player's turn" do
      # first reduce player life via computer attack
      state = Game.info()
      Game.update(state)

      capture_io(fn ->
        Actions.attack(:move_avg)
      end)

      # now switch back to player turn
      state = Game.info()
      Game.update(state)

      player_life_before = Game.fetch_player(:player).life

      capture_io(fn ->
        Actions.heal()
      end)

      player_life_after = Game.fetch_player(:player).life
      assert player_life_after >= player_life_before
    end

    test "heals the computer when it is computer's turn" do
      # first reduce computer life
      capture_io(fn ->
        Actions.attack(:move_avg)
      end)

      computer_life_before = Game.fetch_player(:computer).life

      capture_io(fn ->
        Actions.heal()
      end)

      computer_life_after = Game.fetch_player(:computer).life
      assert computer_life_after >= computer_life_before
    end
  end
end
