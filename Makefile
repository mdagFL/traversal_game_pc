# Recursive idea: copy all subdir lib files to root lib directory
# includes?

SOURCE_DIR := source/
INCLUDE_DIR := include/
DEPENDENCY_DIR := vendor/in-tree/
BIN_DIR := bin/
LIB_DIR := lib/
RECURSIVE_LIB_DIR := lib/dep/
RECURSIVE_LIB_INCLUDE_DIR := lib/dep/include/
OUT_NAME := hamster_crank
OUT_LIBS :=J
OUT_EXECUTABLES := $(OUT_NAME)

OUT_FILES = $(if $(OUT_EXECUTABLES),$(OUT_EXECUTABLES),$(if $(OUT_LIBS),$(OUT_LIBS),"CONFIG_FAIL"))# $(if ifdef($(OUT_LIBS)), CONFIG_YES, CONFIG_ERROR))DEPENDENCY_SUBDIRS := $(addsuffix /,$(wildcard $(DEPENDENCY_DIR)*))
DEPENDENCY_SUBDIRS := $(addsuffix /,$(wildcard $(DEPENDENCY_DIR)*))
DEPENDENCY_INCLUDE_DIRS := $(addprefix $(DEPDNENCY_SUBDIRS),$(INCLUDE_DIR))
DEPENDENCY_LIBS := $(foreach dir,$(DEPENDENCY_SUBDIRS),$(wildcard $(dir)$(LIB_DIR)*.a))
DEPENDENCY_DEP_LIBS := $(foreach dir,$(DEPENDENCY_SUBDIRS),$(wildcard $(dir)$(RECURSIVE_LIB_DIR)*.a))
#DEPENDENCY_DEP_FILES := $(foreach dir,$(DEPENDENCY_SUBDIRS),$(wildcard $(dir)$(RECURSIVE_LIB_DIR)*.d))
DEPENDENCY_INCLUDE_DIRS := $(foreach subdir, $(DEPENDENCY_SUBDIRS), $(subdir)$(INCLUDE_DIR))
RECURSIVE_DEPENDENCY_INCLUDE_DIRS := $(foreach subdir, $(DEPENDENCY_SUBDIRS), $(subdir)$(RECURSIVE_LIB_INCLUDE_DIR))
DEPENDENCY_INCLUDE_FILES := $(foreach subdir,$(DEPENDENCY_SUBDIRS), $(wildcard $(subdir)$(INCLUDE_DIR)*.h))
RECURSIVE_DEPENDENCY_INCLUDE_FILES := $(foreach subdir,$(DEPENDENCY_SUBDIRS),$(wildcard $(subdir)$(RECURSIVE_LIB_INCLUDE_DIR)*.h))

# OUT OF TREE DEPENDENCIES
GLEW_CFLAGS := $(shell pkg-config --cflags --libs --static glew)
GLFW_CFLAGS := $(shell pkg-config --cflags --libs --static glfw3)
OUT_OF_TREE_DEPENDENCY_CFLAGS = $(GLEW_CFLAGS) $(GLFW_CFLAGS)

# DEPENDENCY_SUBDIRS := $(DEPENDENCYDIR)hamster_crank/ $(DEPENDENCYDIR)hamster_crank/vendor/repos/c_utils
# TODO: below works but sucks
# DEPENDENCY_LIBS := $(DEPENDENCYDIR)hamster_crank/bin/hamster_crank.a $(DEPENDENCYDIR)hamster_crank/vendor/repos/c_utils/bin/c_utils.a

# TODO: -Xlinker vs -l? -l does not work for this?
# Set only if dependency subdirs is not empty
DEPENDENCY_CFLAGS := $(if $(DEPENDENCY_SUBDIRS),$(addprefix -Xlinker ,$(DEPENDENCY_LIBS) $(DEPENDENCY_DEP_LIBS)))

INCLUDE_DIRS := $(INCLUDE_DIR) $(DEPENDENCY_INCLUDE_DIRS) $(RECURSIVE_DEPENDENCY_INCLUDE_DIRS)
INCLUDE_CFLAGS := $(addprefix -I , $(INCLUDE_DIRS))
SOURCE := $(wildcard $(SOURCE_DIR)*.c)
SOURCE_CFLAGS := 
#INCLUDE := $(wildcard $(INCLUDE)
OBJECTS := $(patsubst $(SOURCE_DIR)%, $(BIN_DIR)%, $(patsubst %.c,%.o,$(SOURCE)))

#TODO: make this better
#OUT_LIBS := $(BUILDDIR)hamster_crank.a

CFLAGS :=  $(INCLUDE_CFLAGS) $(DEPENDENCY_CFLAGS) $(OUT_OF_TREE_DEPENDENCY_CFLAGS)

.PHONY : all
all : deps $(OUT_FILES)

.PHONY: deps 
deps :$(DEPENDENCY_SUBDIRS) $(RECURSIVE_LIB_INCLUDE_DIR) $(LIB_DIR)
	echo deps
ifdef DEPENDENCY_SUBDIRS # do nothing if no subdirs
	echo subdir exists
	$(MAKE) -C $(DEPENDENCY_SUBDIRS)
	$(foreach file,$(DEPENDENCY_LIBS),cp $(file) $(RECURSIVE_LIB_DIR))
ifdef NESTED_INCLUDE_HEADERS
	$(foreach file,$(NESTED_INCLUDE_HEADERS),cp $(file) $(RECURSIVE_LIB_INCLUDE_DIR))
endif
endif
ifdef RECURSIVE_DEPENDENCY_INCLUDE_FILES # copy DEPENDENCY_DEP_INCLUDES h files if they exist
	$(foreach file,$(RECURSIVE_DEPENDENCY_INCLUDE_FILES),cp $(file) $(RECURSIVE_LIB_INCLUDE_DIR))
endif
ifdef DEPENDENCY_DEP_LIBS # copy DEPENDENCY_DEP_LIBS if they exist
	$(foreach file,$(DEPENDENCY_DEP_LIBS),cp $(file) $(RECURSIVE_LIB_DIR))
endif

# TODO: make it so this doesn't change
$(OUT_FILES) : $(OBJECTS) $(DEPENDENCY_SUBDIRS) $(RECURSIVE_LIB_DIR) $(RECURSIVE_LIB_INCLUDE_DIR) $(LIB_DIR)
	echo OUT_FILES
ifeq ($(OUT_FILES), $(OUT_LIBS))
	ar rvs $(LIB_DIR)$(OUT_LIBS) $(OBJECTS)
else
ifeq ($(OUT_FILES), $(OUT_EXECUTABLES))
	gcc -Xlinker $(OBJECTS) $(CFLAGS) -o $(OUT_EXECUTABLES) -Wl,-rpath=/usr/lib64/
else
	echo OUT_FILES INVALID
endif
endif
$(OBJECTS) : $(INCLUDE) $(SOURCE) $(BIN_DIR)
	echo objects
	echo OUTER_MAKEFILE
	echo $(INCLUDE_CFLAGS)
	echo $(DEPENDENCY_SUBDIRS)
	echo $(DEPENDENCY_INCLUDE_DIRS)
	echo wildcard
	echo $(addsuffix /,$(wildcard $(DEPENDENCY_DIR)*))
	gcc $(CFLAGS) -c $(SOURCE)
	mv *.o $(BIN_DIR)
$(RECURSIVE_LIB_DIR) :
	mkdir $(RECURSIVE_LIB_DIR)
$(RECURSIVE_LIB_INCLUDE_DIR) :
	echo MAKE RECURSIVE_LIB_INCLUDE_DIR
	mkdir $(RECURSIVE_LIB_INCLUDE_DIR)
$(BIN_DIR) :
	echo MAKE BIN_DIR
	mkdir $(BIN_DIR)
$(LIB_DIR) :
	echo MAKE LIB_DIR
	mkdir $(LIB_DIR)


.PHONY : clean
clean :
ifdef BIN_DIR
	rm $(BIN_DIR)*
endif
ifdef LIB_DIR
	rm $(LIB_DIR)*
endif
#mkdir $(RECURSIVE_LIB_DIR)

.PHONY : test
test :
	# SOURCE DIR:
	echo $(SOURCE_DIR)
	
	# INCLUDE DIRS:
	echo $(INCLUDE_DIRS)
	
	# BIN DIR:
	echo $(BIN_DIR)

	# LIB DIR
	echo $(LIB_DIR)
	
	# DEPENDENCY DIR:
	echo $(DEPENDENCY_DIR)

	# DEP LIB DIR
	echo $(RECURSIVE_LIB_DIR)
	
	# DEPENDENCY SUBDIRS
	echo $(DEPENDENCY_SUBDIRS)

	# DEPENDENCY LIBS
	echo $(DEPENDENCY_LIBS)

	# DEPENDENCY DEP LIBS
	echo $(DEPENDENCY_DEP_LIBS)

	# DEPENDENCY DEP FILES
	echo $(DEPENDENCY_DEP_FILES)

	# DEPENDENCY DEP INCLUDES
	echo $(RECURSIVE_DEPENDENCY_INCLUDE_DIRS)

	# RECURSIVE LIB INCLUDE DIR
	echo $(RECURSIVE_LIB_INCLUDE_DIR)

	# DEPENDENCY CFLAGS
	echo $(DEPENDENCY_CFLAGS)

	# SOURCE FILES:
	echo $(SOURCE)
	
	# HEADER FILES:
	echo $(INCLUDE)
	
	# OBJECT FILES:
	echo $(OBJECTS)

	# CFLAGS
	echo $(CFLAGS)

	# OUT_LIBS
	echo $(OUT_LIBS)

	# OUT_EXECUTABLES
	echo $(OUT_EXECUTABLES)
	
	# OUT_FILES
	echo $(OUT_FILES)
