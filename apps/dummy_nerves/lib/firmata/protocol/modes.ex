defmodule Firmata.Protocol.Modes do
  defmacro __using__(_) do
    quote location: :keep do
      @output 0x01
    end
  end
end
