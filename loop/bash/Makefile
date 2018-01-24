##
# cupubot-bash
# Cupubot is a Telegram bot. Just another learning project
##

PREFIX ?= /usr/local
bindir        = $(PREFIX)/bin
libdir        = $(PREFIX)/lib

# default target
all: doc

doc: 
	@echo "Nothing to do..."

# aux
install:
	@echo "Installing..."
	# Scripts
	@install -D -m755 ./cupubot-bash $(DESTDIR)$(bindir)/cupubot-bash
	# Libs
	@mkdir -p $(DESTDIR)$(libdir)/cupubot
	@install -D -m644 ./*.bash $(DESTDIR)$(libdir)/cupubot

uninstall:
	@echo "Uninstalling..."
	# Scripts
	@rm $(DESTDIR)$(bindir)/cupubot-bash
	# Libs
	@rm -r $(DESTDIR)$(libdir)/cupubot

clean:
	@echo "Cleaning..."

.PHONY: install uninstall clean
