defmodule RclexSamples.SimplePubSub do
  @moduledoc """
    The sample which makes nodes as Publisher and Subscriber.
  """
  def main(num_node) do
    context = Rclex.rclexinit()
    # |> node_list,
    node_list = Rclex.create_nodes(context, 'test_pubsub_node', num_node)
    # |> subscribers_list
    subscriber_list = Rclex.create_subscribers(node_list, 'testtopic_sub', :single)

    {sub_sv, sub_child} =
      Rclex.Subscriber.subscribe_start(subscriber_list, context, &sub_callback/1)

    publisher_list = Rclex.create_publishers(node_list, 'testtopic_pub', :single)
    {pub_sv, pub_child} = Rclex.Timer.timer_start(publisher_list, 1000, &pub_callback/1, 100)

    Rclex.waiting_input(pub_sv, pub_child)
    Rclex.waiting_input(sub_sv, sub_child)
    Rclex.publisher_finish(publisher_list, node_list)
    Rclex.subscriber_finish(subscriber_list, node_list)
    Rclex.node_finish(node_list)
    Rclex.shutdown(context)
  end

  def pub_callback(publisher_list) do
    n = length(publisher_list)
    msg_list = Rclex.initialize_msgs(n, :string)
    data = "hello,world"
    # Set data.
    Enum.map(0..(n - 1), fn index ->
      Rclex.setdata(Enum.at(msg_list, index), data, :string)
    end)

    # Publish topics.
    Rclex.Publisher.publish(publisher_list, msg_list)
  end

  # Describe callback function.
  def sub_callback(msg) do
    received_msg = Rclex.readdata_string(msg)
    IO.puts("received msg:#{received_msg}")
  end
end
