#TODO: linker issues further down dependency chain

SOURCEDIR := source/
BUILDDIR := bin/
DEPENDENCYDIR := vendor/
GENERAL_INCLUDE_DIR := include/
DEPENDENCY_SUBDIRS := $(DEPENDENCYDIR)repos/hamster_crank/
INCLUDE_DIRS := $(addprefix -I ,$(GENERAL_INCLUDE_DIR) $(addprefix -I ,$(addsuffix $(GENERAL_INCLUDE_DIR),$(DEPENDENCY_SUBDIRS))))
SOURCE := $(wildcard $(SOURCEDIR)*.c)
INCLUDE := $(wildcard $(INCLUDE_DIRS)*.h)
#INCLUDE := $(addprefix $(INCLUDE_DIRS),$(patsubst %.cpp,%.h,$(wildcard *.cpp)))
OBJECTS := $(patsubst $(SOURCEDIR)%, $(BUILDDIR)%, $(patsubst %.c,%.o,$(SOURCE)))

#TODO: make this better
#OUT_LIBS := $(BUILDDIR)hamster_crank.a
OUT_EXECUTABLES := $(BUILDDIR)traversal_game_pc

GLEW_CFLAGS := $(shell pkg-config --cflags --libs --static glew)
GLFW_CFLAGS := $(shell pkg-config --cflags --libs --static glfw3)

#TODO: ideally eliminate this
VENDOR_ADDITIONAL_INCLUDE_CFLAGS := -I ./$(DEPENDENCYDIR) -Xlinker /home/tusk/dev/git/traversal_game_pc/vendor/repos/hamster_crank/bin/hamster_crank.o #TODO: .a file not working

CFLAGS :=  $(INCLUDE_DIRS) $(VENDOR_ADDITIONAL_INCLUDE_CFLAGS) $(GLFW_CFLAGS) $(GLEW_CFLAGS)

.PHONY : all
all : deps $(OUT_EXECUTABLES)

.PHONY: deps 
deps :$(DEPENDENCY_SUBDIRS)
	$(MAKE) -C $(DEPENDENCY_SUBDIRS)

# TODO: make it so this doesn't change
$(OUT_EXECUTABLES) : $(OBJECTS) $(DEPENDENCY_SUBDIRS)
	echo out_executables
	echo $(VENDOR_ADDITIONAL_INCLUDE_CFLAGS)
	gcc -Xlinker $(OBJECTS) $(CFLAGS) -o $(OUT_EXECUTABLES) -Wl,-rpath=/usr/lib64/
$(OBJECTS) : $(INCLUDE) $(SOURCE)
	echo objects
	#$(MAKE) -C $(DEPENDENCYDIR) # run dependency makefile first
	gcc $(CFLAGS) -c $(SOURCE)
	mv *.o $(BUILDDIR)

.PHONY : clean
clean :
	rm bin/*

.PHONY : test

test :
	# SOURCE DIR:
	echo $(SOURCEDIR)
	
	# INCLUDE DIR:
	echo $(INCLUDE_DIRS)
	
	# BUILD DIR:
	echo $(BUILDDIR)
	
	# DEPENDENCY DIR:
	echo $(DEPENDENCYDIR)
	
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
