TOP_DIR = .
INC_DIR = $(TOP_DIR)/inc
SRC_DIR = $(TOP_DIR)/src
BUILD_DIR = $(TOP_DIR)/build

CC=gcc


default:run

clean:
	-rm -f ./bin/gui

gui: clean
	$(CC) ./src/main.c -o ./bin/gui -lncurses

run: gui
	./bin/gui
