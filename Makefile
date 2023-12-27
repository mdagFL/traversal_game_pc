# Project vars for make
SOURCE_DIR := source/
INCLUDE_DIR := include/
DEPENDENCY_DIR := vendor/in-tree/
BIN_DIR := bin/
LIB_DIR := lib/
RECURSIVE_LIB_DIR := lib/dep/
RECURSIVE_LIB_INCLUDE_DIR := lib/dep/include/
OUT_NAME := hamster_crank
# If this is a library, set OUT_LIBS := $(OUT_NAME).a, otherwise set OUT_EXECUTABLES.
OUT_LIBS :=
OUT_EXECUTABLES := $(OUT_NAME)

include Makefile-common