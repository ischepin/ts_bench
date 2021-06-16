defmodule TsBench.Worker do
  def start_worker(name, task, sleep_period, iterations \\ :infinity) do
    Task.async(fn -> loop(name, task, sleep_period, iterations) end)
  end

  def loop(name, task, sleep_period, iterations) do
    case iterations do
      :infinity ->
        exec(name, task)
        Process.sleep(sleep_period)
        loop(name, task, sleep_period, iterations)

      x when is_number(x) and x > 0 ->
        exec(name, task)
        Process.sleep(sleep_period)
        loop(name, task, sleep_period, x - 1)

      0 ->
        IO.puts("task #{name} finished")
    end
  end

  defp exec(name, task) do
    try do
      {time, _} = :timer.tc(task)
      IO.puts("Task #{name} took #{time / 1000} ms")
    rescue
      e -> IO.inspect(e, label: "worker #{name} error")
    end
  end
end
