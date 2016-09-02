defmodule BadgeLib.FirmataTest do
  use ExUnit.Case

  alias Firmata.Board
  alias BadgeLib.Firmata

  setup do
    {:ok, firmata} = Firmata.start_link
    board = Firmata.board
    {:ok, firmata: firmata, board: board}
  end

  test "writing text to the screen", %{board: board} do
    Firmata.text("Hi there")
    assert [{:sysex_write, {130, "Hi there"}}] == Board.write_log(board)
  end
end
