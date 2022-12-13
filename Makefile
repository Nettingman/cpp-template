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

COMP_FLAGS := -Wall -Werror -Wextra
DEP_FLAGS = -MT $@ -MMD -MP -MF $(@:.o=.td)
POSTCOMPILE = mv -f $(@:.o=.td) $(@:.o=.d) && touch $@
BIN_FULL := $(BIN_DIR)/$(BIN_NAME)

all: debug
debug: COMP_FLAGS += -g
debug: $(BIN_FULL)
release: $(BIN_FULL)

clean:
	rm -rf -- $(BIN_DIR) $(OBJ_DIR)

COMP = $(CXX) $(DEP_FLAGS) $(COMP_FLAGS) -I $(HEA_DIR) -I $(SRC_DIR) -c

$(BIN_FULL): $(OBJS) | $(OBJ_DIR) $(BIN_DIR)
	$(CXX) $(OBJS) $(COMP_FLAGS) -o $@


$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c* $(OBJ_DIR)/%.d
	@mkdir -p $(dir $@)
	@$(COMP) $< -o $@
	@$(POSTCOMPILE)

$(OBJ_DIR) $(BIN_DIR):
	@mkdir -p $@

$(DEPS):
include $(wildcard $(DEPS))


.PHONY: default clean
