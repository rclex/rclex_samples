defmodule RclexSamplesTest do
  use ExUnit.Case
  doctest RclexSamples

  test "greets the world" do
    assert RclexSamples.hello() == :world
  end
end
