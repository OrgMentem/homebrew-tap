class Inscribi < Formula
  desc "Local-first academic feedback engine for instructor-reviewed marking"
  homepage "https://github.com/enieuwy/inscribi"
  # Pinned to the fetchable commit on the private source repo's main branch.
  # Bump `revision` (and `version`) on each release; see README for the flow.
  url "https://github.com/enieuwy/inscribi.git",
      revision: "de1d1a6cdd5d13c69eaa247e47f9176fd557fa37"
  version "1.0.0"

  # uv owns Python resolution: the dependency tree includes heavy/non-PyPI
  # packages (docling -> torch, spaCy + a URL-sourced model wheel declared in
  # [tool.uv.sources]) that a standard checksummed-resource formula cannot
  # represent. uv reads the project's pyproject.toml and honors those sources.
  depends_on "uv"

  def install
    # Keep the managed tool environment fully inside the Cellar so brew can
    # track and clean it up.
    ENV["UV_TOOL_DIR"] = libexec/"tools"
    ENV["UV_TOOL_BIN_DIR"] = libexec/"bin"

    # Install with the browser-UI extras so `inscribi serve` works out of the
    # box (textual + textual-serve). uv fetches a managed CPython 3.13.
    system "uv", "tool", "install", "--python", "3.13", ".[tui,tui-web]"

    bin.install_symlink libexec/"bin/inscribi"
  end

  test do
    assert_match "inscribi", shell_output("#{bin}/inscribi --help")
  end
end
