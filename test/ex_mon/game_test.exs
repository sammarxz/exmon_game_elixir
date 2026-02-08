defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  setup do
    computer = Player.build("Ash", :kick, :punch, :heal)
    player = Player.build("Sam", :kick, :punch, :heal)
    Game.start(computer, player)

    :ok
  end

  describe "start/2" do
    test "initializes the game with correct state" do
      info = Game.info()

      assert info.status == :started
      assert info.turn == :player
      assert info.player.name == "Sam"
      assert info.computer.name == "Ash"
    end

    test "both players start with 100 life" do
      info = Game.info()

      assert info.player.life == 100
      assert info.computer.life == 100
    end

    test "can restart the game when agent is already running" do
      new_player = Player.build("New", :kick, :punch, :heal)
      new_computer = Player.build("NewPC", :kick, :punch, :heal)

      Game.start(new_computer, new_player)
      info = Game.info()

      assert info.player.name == "New"
      assert info.computer.name == "NewPC"
      assert info.status == :started
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      info = Game.info()

      assert is_map(info)
      assert Map.has_key?(info, :player)
      assert Map.has_key?(info, :computer)
      assert Map.has_key?(info, :turn)
      assert Map.has_key?(info, :status)
    end
  end

  describe "player/0" do
    test "returns the player struct" do
      player = Game.player()

      assert %Player{} = player
      assert player.name == "Sam"
    end
  end

  describe "turn/0" do
    test "returns the current turn" do
      assert Game.turn() == :player
    end
  end

  describe "fetch_player/1" do
    test "returns player data when given :player" do
      player = Game.fetch_player(:player)

      assert %Player{} = player
      assert player.name == "Sam"
    end

    test "returns computer data when given :computer" do
      computer = Game.fetch_player(:computer)

      assert %Player{} = computer
      assert computer.name == "Ash"
    end
  end

  describe "update/1" do
    test "sets status to :game_over when player life reaches 0" do
      state =
        Game.info()
        |> put_in([:player, Access.key(:life)], 0)

      Game.update(state)
      info = Game.info()

      assert info.status == :game_over
    end

    test "sets status to :game_over when computer life reaches 0" do
      state =
        Game.info()
        |> put_in([:computer, Access.key(:life)], 0)

      Game.update(state)
      info = Game.info()

      assert info.status == :game_over
    end

    test "sets status to :continue when both players are alive" do
      state = Game.info()
      Game.update(state)
      info = Game.info()

      assert info.status == :continue
    end

    test "switches turn from :player to :computer" do
      state = Game.info()
      Game.update(state)
      info = Game.info()

      assert info.turn == :computer
    end

    test "switches turn from :computer to :player" do
      state = Game.info()
      Game.update(state)

      state2 = Game.info()
      Game.update(state2)
      info = Game.info()

      assert info.turn == :player
    end

    test "does not switch turn on game over" do
      state =
        Game.info()
        |> put_in([:player, Access.key(:life)], 0)

      Game.update(state)
      info = Game.info()

      assert info.status == :game_over
      assert info.turn == :player
    end
  end
end
