defmodule RclexSamples.SimplePubFull do
  @moduledoc """
    The sample which makes any number of publishers.
  """
  def pub_main(num_node) do
    Rclex.rclexinit()
    |> Rclex.create_nodes('test_pub_node', num_node)
    |> Rclex.create_publishers('testtopic', :single)
    |> Rclex.Timer.timer_start(1000, &pub_func/1)

  end

  @doc """
    Timer event callback function defined by user.
  """
  def pub_func(publisher_list) do
    # Create messages according to the number of publishers.
    n = length(publisher_list)
    msg_list = Rclex.initialize_msgs(n, :string)
    data = "hello, world"
    IO.puts("publish message: #{data}")
    # Set data.
    Enum.map(0..(n - 1), fn index ->
      Rclex.setdata(Enum.at(msg_list, index), data, :string)
    end)

    # Publish topics.
    # IO.puts("pub time:#{:os.system_time(:microsecond)}")
    Rclex.Publisher.publish(publisher_list, msg_list)
  end
end
