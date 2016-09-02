defmodule Firmata.Board do
  use GenServer
  require Logger

  @moduledoc """
  Fake version of [Firmata.Board](https://github.com/mobileoverlord/firmata/blob/master/lib/firmata/board.ex).

  Supplies methods called in the Badge project, and also logs the calls for testing.

  Inspect the log with `write_log`
  """

  defstruct port: nil, serial_opts: nil, write_log: []

  def start_link(port, serial_opts \\ []) do
    GenServer.start_link(__MODULE__, {port, serial_opts})
  end

  def sysex_write(pid, arg1, arg2) do
    GenServer.call(pid, {:write, :sysex_write, {arg1, arg2}})
  end

  def digital_write(pid, arg1, arg2) do
    GenServer.call(pid, {:write, :digial_write, {arg1, arg2}})
  end

  def set_pin_mode(pid, pin, mode) do
    GenServer.call(pid, {:write, :pin_mode, {pin, mode}})
  end


  def write_log(pid) do
    GenServer.call(pid, :write_log)
  end

  def clear_write_log(pid) do
    GenServer.call(pid, :clear_write_log)
  end

  def init({port, serial_opts}) do
    {:ok, %__MODULE__{port: port, serial_opts: serial_opts}}
  end

  def handle_call({:write, type, args}, _from, state = %{write_log: write_log}) do
    Logger.debug "Firmate board write #{type}: #{inspect(args)}"

    updated_write_log = [{type, args} | write_log]

    {:reply, :ok, %{state | write_log: updated_write_log}}
  end

  def handle_call(:write_log, _from, state = %{write_log: write_log}) do
    {:reply, Enum.reverse(write_log), state}
  end

  def handle_call(:clear_write_log, _from, state) do
    {:reply, :ok, %{state | write_log: []}}
  end

end
