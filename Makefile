PROJECT ?= radxa-firmware
PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib
MANDIR ?= $(PREFIX)/share/man

.PHONY: all
all: build

#
# Test
#
.PHONY: test
test:

#
# Build
#
.PHONY: build
build: build-doc

SRC-DOC		:=	.
DOCS		:=	$(SRC-DOC)/SOURCE
.PHONY: build-doc
build-doc: $(DOCS)

$(SRC-DOC):
	mkdir -p $(SRC-DOC)

.PHONY: $(SRC-DOC)/SOURCE
$(SRC-DOC)/SOURCE: $(SRC-DOC)
	echo -e "git clone $(shell git remote get-url origin)\ngit checkout $(shell git rev-parse HEAD)" > "$@"

#
# Clean
#
.PHONY: distclean
distclean: clean

.PHONY: clean
clean: clean-doc clean-deb

.PHONY: clean-doc
clean-doc:
	rm -rf $(DOCS)

.PHONY: clean-deb
clean-deb:
	rm -rf debian/.debhelper debian/${PROJECT} debian/debhelper-build-stamp debian/files debian/*.debhelper.log debian/*.postrm.debhelper debian/*.substvars

#
# Release
#
.PHONY: dch
dch: debian/changelog
	gbp dch --debian-branch=main

.PHONY: deb
deb: debian
	debuild --no-sign
