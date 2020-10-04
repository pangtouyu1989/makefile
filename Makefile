vpath %.cpp Source#:add
ver = debug #根据  make ver=release 命令判断生成release or debug版本
CXXFLAGS = -Wall -c -std=c++11
ifeq ($(ver),debug)
	CXXFLAGS += -g -Ddebug
else
	CXXFLAGS += -o3
endif

SRC_DIR = ./Source #./add     #添加所有包含cpp文件的文件夹
OBJ_DIR = ./obj
TAR_DIR = ./bin
TARGET_NAME = First.elf
SRC = $(foreach dir,$(SRC_DIR),$(wildcard $(dir)/*.cpp ))
$(info "SRC:$(SRC)")#输出信息
OBJ = $(addprefix $(OBJ_DIR)/,$(patsubst %.cpp,%.o,$(notdir $(SRC))))
$(info "OBJ:$(OBJ)")
#./obj/add.o
INCLUDE = \
						-I./Include
#SRC_OBJ = $(DEC:.cpp = .o)
TARGET  = $(addprefix $(TAR_DIR)/,$(TARGET_NAME))
DEBUG = -g -o2     #DEBUG 值可以不赋值 如在make DEBUG = "-g -o2|-D_DEBUG"也可以
CFLAGS = $(DEBUG) -Wall -c
LIB_PATH = -L /path
LIBS = -lfun
RM = rm -rf
CXX := g++
PWD = $(shell pwd)
VERSION = 1.0.0.1

all: dir_create $(TARGET)

define CRT_DIR
	if [ ! -d $(1) ];\
	 	then\
    	mkdir -p $(1);\
    	echo "******$(1) created success!!!******";\
    else\
    	echo "******$(1) has been created!!!******";\
	fi	
endef

dir_create:# 创建对应的目录
	@$(call CRT_DIR,$(OBJ_DIR))
	@$(call CRT_DIR,$(TAR_DIR))


$(TARGET):$(OBJ)
	@echo $(PWD)
#	$(CXX)  $(SRC_OBJ) -o $(SRC_BIN) $(INCLUDE) #$(LIB_PATH) $(LIBS)
	$(CXX)  $^ -o $@ 
#$(OBJ_DIR)/%.o:$(SRC_DIR)/%.cpp
$(OBJ_DIR)/%.o:%.cpp #自动去source目录下查找对应的.cpp文件（vpath 设置查找路径）
	$(CXX) $(CXXFLAGS) $< -o $@ $(INCLUDE)

.PHONY:clean
clean:
	$(RM) $(TARGET) $(OBJ_DIR)/*
# -llib 适用于动态库 lib = lib.a适用于静态库
#  动态库必须以lib开头.so结尾
#  生成动态库
#  编译 g++ -c -fPIC $^ -o $@
#  链接 g++ -shared -o -fPIC -o $@ $^
