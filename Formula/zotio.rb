# typed: false
# frozen_string_literal: true

# This file mirrors what goreleaser's brews pipe renders. It is committed
# manually until a fine-grained PAT (contents:write on this repo only) is
# added to OrgMentem/zotio as HOMEBREW_TAP_GITHUB_TOKEN and skip_upload is
# flipped off in .goreleaser.yaml.
class Zotio < Formula
  desc "Zotero automation CLI: local-first search, library health checks, preview-first writes, annotation export, and MCP"
  homepage "https://github.com/OrgMentem/zotio"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/OrgMentem/zotio/releases/download/v0.1.0/zotio_0.1.0_darwin_arm64.tar.gz"
      sha256 "83a9845ae9e2f915be9a5bee14546c294d03b55a60ff1394aff8ffb7ba480865"
    else
      url "https://github.com/OrgMentem/zotio/releases/download/v0.1.0/zotio_0.1.0_darwin_amd64.tar.gz"
      sha256 "840426d9c2fa21c2d674f3dc1ec2ad0c40052c14816bc92f6c7abb3dd0568918"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/OrgMentem/zotio/releases/download/v0.1.0/zotio_0.1.0_linux_arm64.tar.gz"
      sha256 "93f373d98dbbd347147280dfef71a845bea61580d76d59b8a14011011b8ede91"
    else
      url "https://github.com/OrgMentem/zotio/releases/download/v0.1.0/zotio_0.1.0_linux_amd64.tar.gz"
      sha256 "b3b096da1b0ac85aabde8f52b143c0bb11610789380146814fbd4fab2e064183"
    end
  end

  def install
    bin.install "zotio"
    bin.install "zotio-mcp"
  end

  test do
    system "#{bin}/zotio", "version"
  end
end
