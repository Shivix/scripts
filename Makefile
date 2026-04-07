BASH_SCRIPTS = screenshot.sh webcam.sh spell.sh fix_tag.sh read_book.sh backup_usb.sh operator_fetch.sh machine_fetch.sh kek.sh
LUA_SCRIPTS = status_bar.lua

PREFIX ?= $(HOME)/.local
INSTALL_DIR = $(PREFIX)/bin/

install:
	mkdir -p $(INSTALL_DIR)
	@for script in $(BASH_SCRIPTS); do \
		install_target="$(INSTALL_DIR)$$(basename -s .sh $$script)"; \
		cp $$script $$install_target; \
		chmod +x $$install_target; \
	done
	@for script in $(LUA_SCRIPTS); do \
		install_target="$(INSTALL_DIR)$$(basename -s .lua $$script)"; \
		cp $$script $$install_target; \
		chmod +x $$install_target; \
	done

uninstall:
	@for script in $(BASH_SCRIPTS); do \
		install_target="$(INSTALL_DIR)$$(basename -s .sh $$script)"; \
		rm $$install_target; \
	done
	@for script in $(LUA_SCRIPTS); do \
		install_target="$(INSTALL_DIR)$$(basename -s .lua $$script)"; \
		rm $$install_target; \
	done

.PHONY: install uninstall
