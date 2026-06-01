MANIFEST := com.citrix.ICAClient.yml
BUILD_DIR := icaclient
GNOME_VERSION := $(shell grep -m1 '^runtime-version:' $(MANIFEST) | cut -d: -f2 | cut -d'#' -f1 | tr -d ' "')

.PHONY: all setup flathub deps build clean

.DEFAULT_GOAL: all

all: clean setup build

setup: flathub deps

flathub:
	flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

deps:
	flatpak install --user -y flathub \
		org.gnome.Platform//$(GNOME_VERSION) \
		org.gnome.Sdk//$(GNOME_VERSION)

build:
	flatpak-builder --user --install --force-clean $(BUILD_DIR) $(MANIFEST)

clean:
	rm -rf $(BUILD_DIR) .flatpak-builder
