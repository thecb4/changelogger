#!/usr/bin/swift sh

import Foundation
import Path // mxcl/Path.swift == 0.16.2

let projectName = "changelogger"
let toolName = "Changelogger"
let executable = "changelogger"
let version = "feature/homebrew"

let releaseTar = "https://gitlab.com/thecb4/\(executable)/-/archive/\(version)/\(projectName)-\(version).tar.gz"

let makefile = #"""
  PROJECT_NAME = \#(executable)
  TOOL_NAME = \#(toolName)
  export EXECUTABLE_NAME = \#(executable)
  VERSION = \#(version)

  PREFIX = /usr/local
  INSTALL_PATH = $(PREFIX)/bin/$(EXECUTABLE_NAME)
  SHARE_PATH = $(PREFIX)/share/$(EXECUTABLE_NAME)
  CURRENT_PATH = $(PWD)
  REPO = https://gitlab.com/thecb4/$(PROJECT_NAME)
  RELEASE_TAR = $(REPO)/-/archive/$(VERSION)/$(PROJECT_NAME)-$(VERSION).tar.gz
  SHA = $(shell curl -L -s $(RELEASE_TAR) | shasum -a 256 | sed 's/ .*//')

  .PHONY: install build uninstall update_brew release

  install: build
    mkdir -p $(PREFIX)/bin
    cp -f .build/release/$(EXECUTABLE_NAME) $(INSTALL_PATH)
  #  mkdir -p $(SHARE_PATH)
  #   cp -R $(CURRENT_PATH)/SettingPresets $(SHARE_PATH)/SettingPresets

  build:
    swift build --disable-sandbox -c release

  uninstall:
    rm -f $(INSTALL_PATH)
    rm -rf $(SHARE_PATH)

  #  format_code:
  #    swiftformat .

  release:

    git add .
    git commit -m "Update to $(VERSION)"
    #git tag $(VERSION)

  publish: archive bump_brew
    echo "published $(VERSION)"

  bump_brew:
    brew update
    brew bump-formula-pr --url=$(RELEASE_TAR) XcodeGen

  archive: build
    ./scripts/archive.sh
  """#

let formula = #"""
  # Documentation: https://docs.brew.sh/Formula-Cookbook
  #                https://rubydoc.brew.sh/Formula
  # PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
  class Changelogger < Formula
    desc "Take control of your changelogs!"
    homepage "https://gitlab.com/thecb4/changelogger"
    url "https://gitlab.com/thecb4/changelogger.git", :using => :git, :tag => "\#(version)"
  # head "https://gitlab.com/thecb4/changelogger.git", :branch => "\#(version)"

    version "\#(version)"

    # depends_on "gmake" => :build

    def install
      # ENV.deparallelize  # if your formula fails when building in parallel
      # Remove unrecognized options if warned by configure
      #system "./configure", "--disable-debug",
      #                      "--disable-dependency-tracking",
      #                      "--disable-silent-rules",
      #                      "--prefix=#{prefix}"
      # system "cmake", ".", *std_cmake_args
      system "gmake", "install" # if this fails, try separate make/make install steps
    end

    test do
      # `test do` will create, run in and delete a temporary directory.
      #
      # This test will fail and we won't accept that! For Homebrew/homebrew-core
      # this will need to be a test that verifies the functionality of the
      # software. Run the test with `brew test changelogger`. Options passed
      # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
      #
      # The installed folder is not in the path, so use the entire path to any
      # executables being tested: `system "#{bin}/program", "do", "something"`.
      system "false"
    end
  end
  """#

do {
  let makefileDir = Path.cwd
  let makefilePath = makefileDir.join("Makefile")
  try makefile.write(to: makefilePath)
  let formulaDir = Path.cwd / "Formula"
  try formulaDir.mkdir()
  let formulaPath = formulaDir.join("changelogger.rb")
  try formula.write(to: formulaPath)
  print(makefile)
  print(formula)
} catch {
  print(error)
}
