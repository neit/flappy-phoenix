defmodule FlappyPhoenix.Game do
  alias __MODULE__
  defstruct [:bird, :pipes, :score, :state, :updated]
  @gravity 0.8
  @tick 100_000_000
  @pipe_height 43
  @min_pipe_gap 10

  def new() do
    %Game{
      state: :ok,
      bird: %{x: 10, y: 35, wings: 0, velocity: 0},
      pipes: [],
      score: 0.0,
      updated: System.monotonic_time() - @tick
    }
  end

  def update(%{state: :ok} = game) do
    time = System.monotonic_time()
    dt = (time - game.updated) / @tick

    game
    |> move_bird
    |> move_pipes
    |> check_for_collisions
    |> add_pipes
    |> Map.put(:score, game.score + 0.1 * dt)
    |> Map.put(:updated, time)
  end

  def update(game), do: game

  def flap(%{state: :ok} = game) do
    %{game | bird: %{game.bird | velocity: 3}}
  end

  def flap(game), do: game

  defp move_bird(game) do
    bird =
      game.bird
      |> Map.put(:wings, rem(game.bird.wings + 1, 4))
      |> Map.put(:velocity, game.bird.velocity - @gravity)
      |> Map.put(:y, min(game.bird.y - 1.5 * game.bird.velocity, 81))

    %{game | bird: bird}
  end

  defp move_pipes(game) do
    pipes =
      game.pipes
      |> Enum.map(fn p -> move_pipe(p) end)
      |> Enum.filter(fn p -> p.x > -10 end)

    %{game | pipes: pipes}
  end

  defp add_pipes(game) do
    case Enum.find(game.pipes, fn p -> p.x > 50 end) do
      nil ->
        down_pipe_y = Enum.random(-30..0)
        up_pipe_y = max(down_pipe_y + @pipe_height + @min_pipe_gap, Enum.random(43..80))

        pipes = [
          %{x: 100, y: down_pipe_y, height: @pipe_height, dir: :down},
          %{x: 100, y: up_pipe_y, height: @pipe_height, dir: :up}
        ]

        %{game | pipes: game.pipes ++ pipes}

      _ ->
        game
    end
  end

  defp move_pipe(pipe) do
    %{pipe | x: pipe.x - 2}
  end

  defp check_for_collisions(game) do
    game
    |> check_y_collisions
    |> check_pipe_collisions
  end

  defp check_y_collisions(game) do
    state =
      case game.bird.y do
        y when y > 80 -> :end
        y when y < 1 -> :end
        _ -> :ok
      end

    %{game | state: state}
  end

  defp check_pipe_collisions(%{state: :ok} = game) do
    state =
      case Enum.find(game.pipes, fn p ->
             game.bird.x > p.x - 2.5 && game.bird.x < p.x + 2.5 &&
               (game.bird.y > p.y and game.bird.y < p.y + p.height)
           end) do
        nil -> :ok
        _ -> :end
      end

    %{game | state: state}
  end

  defp check_pipe_collisions(game), do: game
end
