defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [app: :issues,
     version: "0.0.1",
     name: "Issues",
     source_url: "https://github.com/ernie/elixir-issues",
     elixir: "~> 0.13.0",
     escript_main_module: Issues.CLI,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [ :httpotion ],
      mod: { Issues, [] }
    ]
  end

  # List all dependencies in the format:
  #
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      { :httpotion, github: "myfreeweb/httpotion" },
      { :jsx,       github: "talentdeficit/jsx" },
      { :ex_doc,    github: "elixir-lang/ex_doc" }
    ]
  end
end
