##
# cupubot-bash
# Cupubot is a Telegram bot. Just another learning project
##

PREFIX ?= /usr/local
bindir        = $(PREFIX)/bin
libdir        = $(PREFIX)/lib
mandir        = $(PREFIX)/man

# default target
all: dummy

dummy: 
	@echo "Nothing to do..."

# auxiliary
install:
	@echo "Installing..."
	# Scripts
	@install -D -m755 ./cupubot-bash $(DESTDIR)$(bindir)/cupubot-bash
	# Libs
	@mkdir -p $(DESTDIR)$(libdir)/cupubot/tasks
	@install -D -m644 ./*.bash $(DESTDIR)$(libdir)/cupubot
	@install -D -m644 ./tasks/*.bash $(DESTDIR)$(libdir)/cupubot/tasks
	# Documentation
	@gzip -k -f ./man/cupubot-bash.1
	@install -D -m644 ./man/cupubot-bash.1.gz $(DESTDIR)$(mandir)/man1/

uninstall:
	@echo "Uninstalling..."
	# Scripts
	@rm $(DESTDIR)$(bindir)/cupubot-bash
	# Libs
	@rm -r $(DESTDIR)$(libdir)/cupubot
	# Documentation
	@rm $(DESTDIR)$(mandir)/man1/cupubot-bash.1.gz

clean:
	@echo "Cleaning..."

.PHONY: install uninstall clean
