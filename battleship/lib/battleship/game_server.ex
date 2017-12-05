defmodule GameServer do
  use GenServer

  # Callbacks

  #TODO: complete method

  # For testing:
  """
  a = b = ["water", "ship", "water"]
  board = [a, b]
  {:ok, pid} = GenServer.start_link(GameServer, board)

  GenServer.call(pid, {:hit, 1, 0})
  GenServer.call(pid, {:update, 0})


"""

  # Join server, add player id to map
  def handle_call({:join, player, ships}, _from, state) do

    board = List.last(List.first(state))

    board = List.replace_at(board, Enum.at(ships, 0), "ship")
    board = List.replace_at(board, Enum.at(ships, 1), "ship")
    board = List.replace_at(board, Enum.at(ships, 2), "ship")
    board = List.replace_at(board, Enum.at(ships, 3), "ship")
    board = List.replace_at(board, Enum.at(ships, 4), "ship")
    board = List.replace_at(board, Enum.at(ships, 5), "ship")
    board = List.replace_at(board, Enum.at(ships, 6), "ship")
    board = List.replace_at(board, Enum.at(ships, 7), "ship")
    board = List.replace_at(board, Enum.at(ships, 8), "ship")
    board = List.replace_at(board, Enum.at(ships, 9), "ship")
    board = List.replace_at(board, Enum.at(ships, 10), "ship")
    board = List.replace_at(board, Enum.at(ships, 11), "ship")
    board = List.replace_at(board, Enum.at(ships, 12), "ship")
    board = List.replace_at(board, Enum.at(ships, 13), "ship")
    board = List.replace_at(board, Enum.at(ships, 14), "ship")
    board = List.replace_at(board, Enum.at(ships, 15), "ship")
    board = List.replace_at(board, Enum.at(ships, 16), "ship")


    newGame = [List.first(List.first(state)), board]

    newUsers = Map.put(Map.put(List.last(state), 1, player), player, 1)

    newState = [newGame, false, newUsers]

    {:reply, 1, newState}

  end

  # {:ok, pid} = GenServer.start_link(GameServer, board)
  # GenServer.call(pid, {:hit, 1, 0})

  # Game's attack
  def handle_call({:hit, pos, player}, _from, state) do


    # Player 0 attacking player 1, or viceversa
    turn = Enum.fetch!(state, 1)
    game = List.first(state)

    {:ok, id} = Map.fetch(List.last(state), player)

    IO.puts id

    playerTurn = if turn, do: 1, else: 0


    if playerTurn == id do

      board = if id == 0 do
        IO.puts("0 is attacking")
        List.last(game)
      else
        IO.puts("1 is attacking")
        List.first(game)
      end

      square = Enum.at(board, pos)

      square = if square == "ship" do
        board = List.replace_at(board, pos, "hit")
        "hit"
      else
        board = List.replace_at(board, pos, "missed")
        "missed"
      end

      newState = if id == 0 do
        [[List.first(game), board], !turn, List.last(state)]
      else
        [[board, List.last(game)], !turn, List.last(state)]
      end

    else


      newState = state

    end

    {:reply, List.first(state), newState}
    #{:reply, square, newState}

  end


  # Returns the current list
  # For the player, it will return the board with complete information
  # For the opponent's board it will replace all the ships for water tiles
  # Player's board will be the first, opponent's will be the second
  def handle_call({:update, player}, _from, state) do


#    IO.puts player
#    IO.puts List.last(state)


    id = Map.fetch(List.last(state), player)
    game = List.first(state)

    board = if id == 0 do

      a = List.first(game)

      opp = List.last(game)
      b = Enum.map(opp, fn(x) -> if x == "ship" do "water" else x end end)

      [b, a]
    else

      opp = List.first(game)
      a = Enum.map(opp, fn(x) -> if x == "ship" do "water" else x end end)

      b = List.last(game)

      [b, a]
    end

    {:reply, board, state}

  end

  # Returns [Boards for player 1, Boards for player 2]
  def handle_call({:update}, _from, state) do

    game = List.first(state)

    playerA = List.first(game)
    oppA = Enum.map(List.last(game), fn(x) -> if x == "ship" do "water" else x end end)

    boardA = [playerA, oppA]

    playerB = List.last(game)
    oppB = Enum.map(List.first(game), fn(x) -> if x == "ship" do "water" else x end end)

    boardB = [playerB, oppB]

    boards = [boardA, boardB]

    {:reply, boards, state}
  end


  # Returns the ids for the players
  def handle_call({:IDs}, _from, state) do

    ids = List.last(state)

    a = Map.get(ids, 0)
    b = Map.get(ids, 1)

    {:reply, [a, b], state}

  end



end