PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
CC=../stage1/cproc
CFLAGS=-std=c99 -Wall -Wpedantic -Wno-parentheses -Wno-switch -g -pipe
LDFLAGS=-s
