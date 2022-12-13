BIN_NAME := program

BIN_DIR := bin
OBJ_DIR := obj

SRC_DIR := src
HEA_DIR := include

SRCS   := $(shell find $(SRC_DIR) -type f -name *.c*)
HEAS   := $(shell find $(HEA_DIR) -type f -name *.h*)
SRCS_BASE := $(basename $(SRCS))

OBJS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(addsuffix .o,$(SRCS_BASE)))
DEPS := $(patsubst $(SRC_DIR)/%,$(OBJ_DIR)/%,$(addsuffix .d,$(SRCS_BASE)))

DEP_FLAGS = -MT $@ -MMD -MP -MF $(@:.o=.d)
BIN_FULL := $(BIN_DIR)/$(BIN_NAME)

COMP = $(CXX) $(DEP_FLAGS) -c

default: $(BIN_FULL)

clean:
	rm -rf -- $(BIN_DIR) $(OBJ_DIR)

$(BIN_FULL): $(OBJS) | $(OBJ_DIR) $(BIN_DIR)
	$(CXX) $(OBJS) -o $@


$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c* $(OBJ_DIR)/%.d
	@mkdir -p $(dir $@)
	$(COMP) $< -o $@

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

$(DEPS):
include $(wildcard $(DEPS))


.PHONY: all clean
