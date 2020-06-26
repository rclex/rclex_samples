defmodule RclexSamples.MultiTopic do
  @moduledoc """
    The sample which makes any number of publisher-topic-subscriber pairs.
    Specify :multi as an argument to create_publishers.
    It is assumed publishing and subscribing between different VMs.
  """
  def pub_main(num_node) do
    context = RclEx.rclexinit()
    node_list = RclEx.create_nodes(context, 'test_pub_node', num_node)
    publisher_list = RclEx.create_publishers(node_list, 'topic', :multi)
    {sv, child} = RclEx.Timer.timer_start(publisher_list, 1000, &timer_callback/1, 100)

    RclEx.waiting_input(sv, child)
    RclEx.publisher_finish(publisher_list, node_list)
    RclEx.node_finish(node_list)
    RclEx.shutdown(context)
  end

  @doc """
    Timer event callback function defined by user.
  """
  def timer_callback(publisher_list) do
    n = length(publisher_list)
    msg_list = RclEx.initialize_msgs(n, :string)
    data = "hello,world"
    # Set data.
    Enum.map(0..(n - 1), fn index ->
      RclEx.setdata(Enum.at(msg_list, index), data, :string)
    end)

    # Publish topics.
    RclEx.Publisher.publish(publisher_list, msg_list)
  end

  def sub_main(num_node) do
    context = RclEx.rclexinit()
    node_list = RclEx.create_nodes(context, 'test_sub_node', num_node)
    subscriber_list = RclEx.create_subscribers(node_list, 'topic', :multi)
    {sv, child} = RclEx.Subscriber.subscribe_start(subscriber_list, context, &callback_sub/1)
    RclEx.waiting_input(sv, child)
    RclEx.subscriber_finish(subscriber_list, node_list)
    RclEx.node_finish(node_list)
    RclEx.shutdown(context)
  end

  # Describe callback function.
  def callback_sub(msg) do
    received_msg = RclEx.readdata_string(msg)
    IO.puts("received msg:#{received_msg}")
  end
end
