# MIT License
# 
# Copyright (c) 2020 Hyeonki Hong <hhk7734@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

prefix = /usr

ifeq ($(strip ${SUDO_USER}),)
	SUDO_USER=${USER}
endif

DEVICE=$(cat /proc/device-tree/model)

.PHONY: all
all:
	@:

.PHONY: install
install:
	install -m 0755 -d $(DESTDIR)$(prefix)/bin
	install -m 0755 -d $(DESTDIR)$(prefix)/lib/odroid-config/debian
	install -m 0755 odroid-config $(DESTDIR)$(prefix)/bin
	install -m 0644 debian/changelog $(DESTDIR)$(prefix)/lib/odroid-config/debian
	install -m 0755 Makefile $(DESTDIR)$(prefix)/lib/odroid-config
	cp -ar models $(DESTDIR)$(prefix)/lib/odroid-config
	chmod 644 $(DESTDIR)$(prefix)/lib/odroid-config/models/*/*

.PHONY: clean
clean:

.PHONY: distclean
distclean: clean

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(prefix)/bin/odroid-config
	rm -rf $(DESTDIR)$(prefix)/lib/odroid-config

.PHONY: shellcheck
shellcheck:
	shellcheck models/*/* odroid-config
