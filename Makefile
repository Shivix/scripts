BASH_SCRIPTS = screenshot.bash webcam.bash spell.bash
LUA_SCRIPTS = status_bar.lua

INSTALL_DIR = /usr/local/bin/

install:
	@for script in $(BASH_SCRIPTS); do \
		install_target="$(INSTALL_DIR)$$(basename -s .bash $$script)"; \
		cp $$script $$install_target; \
		chmod +x $$install_target; \
	done
	@for script in $(LUA_SCRIPTS); do \
		install_target="$(INSTALL_DIR)$$(basename -s .lua $$script)"; \
		cp $$script $$install_target; \
		chmod +x $$install_target; \
	done

.PHONY: install
