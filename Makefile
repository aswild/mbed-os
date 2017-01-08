#######################################################################
#  Copyright 2017 Allen Wild
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#######################################################################

# Defaults
DEFAULT_TARGET      := LPC1768,LPC1114
DEFAULT_TOOLCHAIN   := GCC_ARM
DEFAULT_PYTHON      := python
DEFAULT_DESTDIR     := /usr/src/mbed

BUILD_SCRIPT        := tools/build.py
BUILD_OUTPUT_DIR    := $(PWD)/.build/mbed

# Option Processing
ifeq ($(BUILDOPTS),)
BUILDOPTS =
endif
ifeq ($(V),1)
BUILDOPTS += -v
endif
ifeq ($(TARGET),)
TARGET := $(DEFAULT_TARGET)
endif
ifeq ($(TOOLCHAIN),)
TOOLCHAIN := $(DEFAULT_TOOLCHAIN)
endif
ifeq ($(PYTHON),)
PYTHON := $(DEFAULT_PYTHON)
endif
ifeq ($(DESTDIR),)
DESTDIR := $(DEFAULT_DESTDIR)
endif

ifneq ($(CFLAGS),)
BUILDOPTS += --cflags $(CFLAGS)
endif
ifneq ($(ASMFLAGS),)
BUILDOPTS += --ASMFLAGS $(ASMFLAGS)
endif
ifneq ($(LDFLAGS),)
BUILDOPTS += --ldflags $(LDFLAGS)
endif

PARALLEL_MAKE = $(filter -j%,$(MAKEFLAGS))

# Targets
all: build
build:
	$(PYTHON) $(BUILD_SCRIPT) $(PARALLEL_MAKE) $(BUILDOPTS) -m $(TARGET) -t $(TOOLCHAIN)

install:
	install -d $(DESTDIR)
	cp -av $(BUILD_OUTPUT_DIR)/* $(DESTDIR)

clean:
	rm -rf $(BUILD_OUTPUT_DIR)

.PHONY: all build install clean
