defmodule ExMon.PlayerTest do
  use ExUnit.Case

  alias ExMon.Player

  describe "build/4" do
    test "returns a player struct with correct fields" do
      player = Player.build("Sam", :kick, :punch, :heal)

      assert %Player{} = player
      assert player.name == "Sam"
      assert player.life == 100
      assert player.moves == %{move_rnd: :kick, move_avg: :punch, move_heal: :heal}
    end

    test "always starts with 100 life points" do
      player = Player.build("Test", :a, :b, :c)

      assert player.life == 100
    end

    test "maps moves correctly to move types" do
      player = Player.build("Test", :fireball, :slash, :potion)

      assert player.moves.move_rnd == :fireball
      assert player.moves.move_avg == :slash
      assert player.moves.move_heal == :potion
    end
  end
end
