defmodule RclexSamples.SimplePub do
  @moduledoc """
    The sample which makes any number of publishers.
  """
  def pub_main(num_node) do
    context = Rclex.rclexinit()
    node_list = Rclex.create_nodes(context, 'test_pub_node', num_node)
    publisher_list = Rclex.create_publishers(node_list, 'testtopic', :single)
    {sv, child} = Rclex.Timer.timer_start(publisher_list, 500, &callback/1, 100)

    # In timer_start/2,3, the number of times that the timer process is executed can be set.
    # If it is not set, the timer process loops forever.
    Rclex.waiting_input(sv, child)

    Rclex.publisher_finish(publisher_list, node_list)

    Rclex.node_finish(node_list)

    Rclex.shutdown(context)
  end

  @doc """
    Timer event callback function defined by user.
  """
  def callback(publisher_list) do
    # Create messages according to the number of publishers.
    n = length(publisher_list)
    msg_list = Rclex.initialize_msgs(n, :string)
    data = "hello,world"
    IO.puts("publish message:#{data}")
    # Set data.
    Enum.map(0..(n - 1), fn index ->
      Rclex.setdata(Enum.at(msg_list, index), data, :string)
    end)

    # Publish topics.
    # IO.puts("pub time:#{:os.system_time(:microsecond)}")
    Rclex.Publisher.publish(publisher_list, msg_list)
  end
end
