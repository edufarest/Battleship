defmodule BattleshipWeb.GameChannel do
  use Phoenix.Channel

  # Code taken from Phoenix's channel guide

  # Main lobby to join a game
  def join("game:lobby", _message, socket) do
    {:ok, socket}
  end


  # TODO: Implement private rooms
  def join("game:" <> _room_id, _params, _socket) do
    {:ok, _socket}
  end

  def handle_in("hit", %{"pos" => pos, "server" => server, "player" => player}, socket) do

    #TODO: Change value if player's turn and broadcast update

    name = String.to_atom(server)

    #IO.puts(String.to_atom(player))

    state = GenServer.call(name, {:hit, pos, player})

    a = List.first(state)
    b = List.last(state)

    if Enum.all?(a, fn(x) -> x != "ship" end) do
      broadcast! socket, "gameOver", %{winner: 2}
    end

    if Enum.all?(b, fn(x) -> x != "ship" end) do
      broadcast! socket, "gameOver", %{winner: 1}
    end



    broadcast! socket, "getUpdate", %{server: server}
    {:noreply, socket}

  end

  # For testing:
  """
    a = b = ["water", "ship", "water"]
    board = [a, b]
    {:ok, pid} = GenServer.start_link(GameServer, board)

    GenServer.call(pid, {:hit, 1, 0})
    GenServer.call(pid, {:update, 0})

  """


  def handle_in("start", %{"name" => name, "player" => player, "ships" => ships}, socket) do


    # Users map
    users = %{0 => player, player => 0}


    # Create boards
    a = List.duplicate("water", 100)
    b = List.duplicate("water", 100)


    a = List.replace_at(a, Enum.at(ships, 0), "ship")
    a = List.replace_at(a, Enum.at(ships, 1), "ship")
    a = List.replace_at(a, Enum.at(ships, 2), "ship")
    a = List.replace_at(a, Enum.at(ships, 3), "ship")
    a = List.replace_at(a, Enum.at(ships, 4), "ship")
    a = List.replace_at(a, Enum.at(ships, 5), "ship")
    a = List.replace_at(a, Enum.at(ships, 6), "ship")
    a = List.replace_at(a, Enum.at(ships, 7), "ship")
    a = List.replace_at(a, Enum.at(ships, 8), "ship")
    a = List.replace_at(a, Enum.at(ships, 9), "ship")
    a = List.replace_at(a, Enum.at(ships, 10), "ship")
    a = List.replace_at(a, Enum.at(ships, 11), "ship")
    a = List.replace_at(a, Enum.at(ships, 12), "ship")
    a = List.replace_at(a, Enum.at(ships, 13), "ship")
    a = List.replace_at(a, Enum.at(ships, 14), "ship")
    a = List.replace_at(a, Enum.at(ships, 15), "ship")
    a = List.replace_at(a, Enum.at(ships, 16), "ship")


    board = [a, b]

    # Board, turn, users
    state = [board, false, users]

    {:ok, pid} = GenServer.start_link(GameServer, state, name: String.to_atom(name))

    broadcast! socket, "start", %{name: name, player: player}
    {:noreply, socket}

  end


  def handle_in("join", %{"name" => name, "player" => player, "ships" => ships}, socket) do

    GenServer.call(String.to_atom(name), {:join, player, ships})

    broadcast! socket, "join", %{name: name, player: player}
    {:noreply, socket}
  end

  def handle_in("update", %{"server" => server, "player" => player}, socket) do


    #    state = GenServer.call(String.to_atom(server), {:update, player})
    state = GenServer.call(String.to_atom(server), {:update})

    broadcast! socket, "update", %{state: state, server: server, player: player}
    {:noreply, socket}
  end


  def handle_in("update", %{"server" => server}, socket) do

    boards = GenServer.call(String.to_atom(server), {:update})

    playersIDs = GenServer.call(String.to_atom(server), {:IDs})

    # Broadcast each boards to their respective player

    channel1 = "update" <> to_string(List.first(playersIDs))
    channel2 = "update" <> to_string(List.last(playersIDs))

    broadcast! socket, channel1, %{state: List.first(boards), server: server}
    broadcast! socket, channel2, %{state: List.last(boards), server: server}

    {:noreply, socket}

  end

end