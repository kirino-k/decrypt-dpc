# Makefile for decrypt-dpc

.PHONY: main
main: script/splitaeskey
	script/main.sh

script/splitaeskey: script/splitaeskey.c
	gcc -o $@ $<

.PHONY: executable
executable:
	chmod +x script/*.sh

.PHONY: clean
clean:
	rm -rf decrypted expanded
	rm -f script/splitaeskey

.PHONY: clean-all
clean-all:
	$(MAKE) clean
	docker image rm -f decrypt-dpc:latest
