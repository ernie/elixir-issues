defmodule Issues.CLI do

  import Issues.TableFormatter, only: [ print_table_for_columns: 2 ]

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that
  end up generating a table of the last _n_ issues in a GitHub project
  """

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  def process(:help) do
    IO.puts """
    usage:  issues <user> <project> [ count | 4 ]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GitHubIssues.fetch(user, project)
      |> decode_response
      |> convert_to_list_of_hashdicts
      |> sort_into_ascending_order
      |> Enum.take(count)
      |> print_table_for_columns(["number", "created_at", "title"])
  end

  def decode_response({:ok, body}), do: :jsx.decode(body)
  def decode_response({:error, msg}) do
    error = :jsx.decode(msg)["message"]
    IO.puts "Error fetching from GitHub: #{error}"
    System.halt(2)
  end

  def convert_to_list_of_hashdicts(list) do
    list |> Enum.map(&Enum.into(&1, HashDict.new))
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues,
              fn i1, i2 -> i1["created_at"] <= i2["created_at"] end
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a GitHub username, project name, and (optionally) the number
  of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if --help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help])
    case parse do

      { [ help: true ], _, _ }
        -> :help

      { _, [ user, project, count ], _ }
        -> { user, project, binary_to_integer(count) }

      { _, [ user, project ], _ }
        -> { user, project, @default_count }

      _ -> :help
    end
  end

end
