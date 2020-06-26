defmodule RclexSamples.SimpleSub do
  @moduledoc """
    The sample which makes any number of subscribers.
  """
  def sub_main(num_node) do
    # Create as many nodes as you specify in num_node
    context = RclEx.rclexinit()
    node_list = RclEx.create_nodes(context, 'test_sub_node', num_node)
    subscriber_list = RclEx.create_subscribers(node_list, 'testtopic', :single)
    {sv, child} = RclEx.Subscriber.subscribe_start(subscriber_list, context, &callback/1)
    RclEx.waiting_input(sv, child)

    RclEx.subscriber_finish(subscriber_list, node_list)
    RclEx.node_finish(node_list)
    RclEx.shutdown(context)
  end

  # Describe callback function.
  def callback(msg) do
    # IO.puts("sub time:#{:os.system_time(:microsecond)}")
    received_msg = RclEx.readdata_string(msg)
    IO.puts("received msg:#{received_msg}")
  end
end
