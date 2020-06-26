defmodule RclexSamples.SimpleSub do
  @moduledoc """
    The sample which makes any number of subscribers.
  """
  def sub_main(num_node) do
    # Create as many nodes as you specify in num_node
    context = Rclex.rclexinit()
    node_list = Rclex.create_nodes(context, 'test_sub_node', num_node)
    subscriber_list = Rclex.create_subscribers(node_list, 'testtopic', :single)
    {sv, child} = Rclex.Subscriber.subscribe_start(subscriber_list, context, &callback/1)
    Rclex.waiting_input(sv, child)

    Rclex.subscriber_finish(subscriber_list, node_list)
    Rclex.node_finish(node_list)
    Rclex.shutdown(context)
  end

  # Describe callback function.
  def callback(msg) do
    # IO.puts("sub time:#{:os.system_time(:microsecond)}")
    received_msg = Rclex.readdata_string(msg)
    IO.puts("received msg:#{received_msg}")
  end
end
