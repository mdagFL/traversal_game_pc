SOURCEDIR := source/
BUILDDIR := bin/
DEPENDENCYDIR := vendor/
GENERAL_INCLUDE_DIR := include/
DEPENDENCY_SUBDIRS := $(DEPENDENCYDIR)hamster_crank/
DEPENDENCY_LIBS := $(wildcard $(DEPENDENCY_SUBDIRS)bin/*.a) 
# TODO: -Xlinker vs -l? -l does not work for this?
DEPENDENCY_CFLAGS := $(addprefix -Xlinker ,$(DEPENDENCY_LIBS))
INCLUDE_DIRS := $(GENERAL_INCLUDE_DIR) $(addsuffix $(GENERAL_INCLUDE_DIR),$(DEPENDENCY_SUBDIRS))
INCLUDE_CFLAGS := $(addprefix -I, $(INCLUDE_DIRS))
SOURCE := $(wildcard $(SOURCEDIR)*.c)
#INCLUDE := $(wildcard $(INCLUDE_DIRS)*.h)
OBJECTS := $(patsubst $(SOURCEDIR)%, $(BUILDDIR)%, $(patsubst %.c,%.o,$(SOURCE)))

#TODO: make this better
#OUT_LIBS := $(BUILDDIR)hamster_crank.a
OUT_EXECUTABLES := $(BUILDDIR)traversal_game_pc

GLEW_CFLAGS := $(shell pkg-config --cflags --libs --static glew)
GLFW_CFLAGS := $(shell pkg-config --cflags --libs --static glfw3)

CFLAGS :=  $(INCLUDE_CFLAGS) $(DEPENDENCY_CFLAGS) $(GLFW_CFLAGS) $(GLEW_CFLAGS)

.PHONY : all
all : deps $(OUT_EXECUTABLES)

.PHONY: deps 
deps :$(DEPENDENCY_SUBDIRS)
	$(MAKE) -C $(DEPENDENCY_SUBDIRS)

# TODO: make it so this doesn't change
$(OUT_EXECUTABLES) : $(OBJECTS) $(DEPENDENCY_SUBDIRS)
	echo out_executables
	gcc -Xlinker $(OBJECTS) $(CFLAGS) -o $(OUT_EXECUTABLES) -Wl,-rpath=/usr/lib64/
$(OBJECTS) : $(INCLUDE) $(SOURCE) $(BUILDDIR)
	echo objects
	#$(MAKE) -C $(DEPENDENCYDIR) # run dependency makefile first
	gcc $(CFLAGS) -c $(SOURCE)
	mv *.o $(BUILDDIR)
$(BUILDDIR) :
	mkdir $(BUILDDIR)

.PHONY : clean
clean :
	rm bin/*

.PHONY : test

test :
	# SOURCE DIR:
	echo $(SOURCEDIR)
	
	# INCLUDE DIRS:
	echo $(INCLUDE_DIRS)
	
	# BUILD DIR:
	echo $(BUILDDIR)
	
	# DEPENDENCY DIR:
	echo $(DEPENDENCYDIR)
	
	# DEPENDENCY SUBDIRS
	echo $(DEPENDENCY_SUBDIRS)

	# DEPENDENCY LIBS
	echo $(DEPENDENCY_LIBS)

	# DEPENDENCY CFLAGS
	echo $(DEPENDENCY_CFLAGS)

	# SOURCE FILES:
	echo $(SOURCE)
	
	# HEADER FILES:
	echo $(INCLUDE)
	
	# OBJECT FILES:
	echo $(OBJECTS)

	# CFLAGS
	echo $(GLEW_CFLAGS)
	echo $(GLFW_CFLAGS)
	echo $(STB_IMAGE_CFLAGS)
	echo $(CFLAGS)
