TOP_DIR = .
INC_DIR = $(TOP_DIR)/inc
SRC_DIR = $(TOP_DIR)/src
BUILD_DIR = $(TOP_DIR)/build
TARGET_DIR = $(TOP_DIR)/bin

TARGET_NAME = temu-gui
SOURCES = $(wildcard $(SRC_DIR)/*.c)
HEADERS = $(wildcard $(INC_DIR)/*.h)

CC = gcc
FLAGS = -lncurses

OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SOURCES))

default: run

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	$(CC) $(FLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET_DIR)/$(TARGET_NAME)

gui: $(OBJECTS)
	$(CC) -o $(TARGET_DIR)/$(TARGET_NAME) $(OBJECTS) $(FLAGS)

run: clean gui
	$(TARGET_DIR)/$(TARGET_NAME)