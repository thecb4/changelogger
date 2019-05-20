.RECIPEPREFIX +=
PROJECT_NAME = changelogger
TOOL_NAME = Changelogger
export EXECUTABLE_NAME = changelogger
VERSION = feature/homebrew

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