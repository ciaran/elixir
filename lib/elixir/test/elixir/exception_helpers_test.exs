Code.require_file "test_helper.exs", __DIR__

defmodule ExceptionHelpersTest do
  use ExUnit.Case, async: true
  import ExceptionHelpers

  test "finds functions of the same name with different arity" do
    assert find_functions(IO, :puts, 0) == [puts: 1, puts: 2]
  end

  test "finds similar functions when no name matches" do
    assert find_functions(IO, :put, 0) == [puts: 1, puts: 2]
  end

  test "undefined function exception message" do
    assert %UndefinedFunctionError{module: File, function: :open, arity: 0}
      |> Exception.message == """
      undefined function File.open/0

          \e[1mPerhaps you meant one of:\e[0m

             File.open/1
             File.open/3                   File.open(path, modes, function)
             File.open/2                   File.open(path, modes \\\\ [])
      """
  end

  test "undefined module exception message" do
    assert %UndefinedFunctionError{module: Filr, function: :open, arity: 1}
      |> Exception.message == """
      undefined function Filr.open/1 (module Filr is not available)

          \e[1mPerhaps you meant one of:\e[0m

             File
      """
  end
end
