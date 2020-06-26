defmodule RclexSamples.SimplePub do
  @moduledoc """
    The sample which makes any number of publishers.
  """
  def pub_main(num_node) do
    context = RclEx.rclexinit()
    node_list = RclEx.create_nodes(context, 'test_pub_node', num_node)
    publisher_list = RclEx.create_publishers(node_list, 'testtopic', :single)
    {sv, child} = RclEx.Timer.timer_start(publisher_list, 500, &callback/1, 100)

    # In timer_start/2,3, the number of times that the timer process is executed can be set.
    # If it is not set, the timer process loops forever.
    RclEx.waiting_input(sv, child)

    RclEx.publisher_finish(publisher_list, node_list)

    RclEx.node_finish(node_list)

    RclEx.shutdown(context)
  end

  @doc """
    Timer event callback function defined by user.
  """
  def callback(publisher_list) do
    # Create messages according to the number of publishers.
    n = length(publisher_list)
    msg_list = RclEx.initialize_msgs(n, :string)
    data = "hello,world"
    IO.puts("publish message:#{data}")
    # Set data.
    Enum.map(0..(n - 1), fn index ->
      RclEx.setdata(Enum.at(msg_list, index), data, :string)
    end)

    # Publish topics.
    # IO.puts("pub time:#{:os.system_time(:microsecond)}")
    RclEx.Publisher.publish(publisher_list, msg_list)
  end
end
