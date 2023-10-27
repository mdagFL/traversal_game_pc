#TODO: linker issues further down dependency chain

SOURCEDIR := source/
INCLUDEDIR := include/
BUILDDIR := bin/
DEPENDENCYDIR := vendor/
SOURCE := $(wildcard $(SOURCEDIR)*.c)
INCLUDE := $(wildcard $(INCLUDEDIR)*.h)
#INCLUDE := $(addprefix $(INCLUDEDIR),$(patsubst %.cpp,%.h,$(wildcard *.cpp)))
OBJECTS := $(patsubst $(SOURCEDIR)%, $(BUILDDIR)%, $(patsubst %.c,%.o,$(SOURCE)))

#TODO: make this better
#OUT_LIBS := $(BUILDDIR)hamster_crank.a
OUT_EXECUTABLES := $(BUILDDIR)traversal_game_pc

GLEW_CFLAGS := $(shell pkg-config --cflags --libs --static glew)
GLFW_CFLAGS := $(shell pkg-config --cflags --libs --static glfw3)

#TODO: ideally eliminate this
VENDOR_ADDITIONAL_INCLUDE_CFLAGS := -I ./$(DEPENDENCYDIR)include/ -Xlinker /home/tusk/dev/git/traversal_game_pc/vendor/repos/hamster_crank/bin/hamster_crank.o #TODO: .a file not working

CFLAGS :=  $(VENDOR_ADDITIONAL_INCLUDE_CFLAGS) $(GLFW_CFLAGS) $(GLEW_CFLAGS)

all : $(OUT_EXECUTABLES)

# TODO: make it so this doesn't change
$(OUT_EXECUTABLES): $(OBJECTS)
	echo $(VENDOR_ADDITIONAL_INCLUDE_CFLAGS)
	gcc -Xlinker $(OBJECTS) $(CFLAGS) -o $(OUT_EXECUTABLES) -Wl,-rpath=/usr/lib64/
$(OBJECTS) : $(INCLUDE) $(SOURCE)
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
	echo $(INCLUDEDIR)
	
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
