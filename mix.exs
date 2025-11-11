defmodule ByteCount.MixProject do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :byte_count,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),

      # Hex
      package: package(),
      description: "Parse and format byte counts with SI & IEC units.",

      # Docs
      name: "ByteCount",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/threatfender/byte_count"
      },
      files: ~w(lib mix.exs .formatter.exs CHANGELOG.md README.md LICENSE)
    ]
  end

  def docs do
    [main: "readme", extras: ["README.md", "CHANGELOG.md"]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      "src.analyze": &analyze_src/1,

      # Hex package
      "pkg.build": &build_pkg/1,
      "pkg.analyze": ["pkg.build", &analyze_pkg/1]
    ]
  end

  ## Package source code

  defp analyze_src(_) do
    Mix.Task.run("dialyzer")
    # Mix.Task.run("credo", ["--all"])
  end

  ## Package archive

  defp build_pkg(_) do
    Mix.Task.run("hex.build")
  end

  defp analyze_pkg(_) do
    archive = "byte_count-#{@version}.tar"
    Mix.Shell.IO.info("\nAnalyzing #{archive}")

    tarsize = File.stat!(archive).size
    Mix.Shell.IO.info("- Size: #{tarsize / 1000} kB")
  end
end
