CC=/opt/llvm-3.9/bin/clang
# CC=/opt/llvm-5.0.0/bin/clang
SYSROOT=-isysroot $(shell xcrun --sdk macosx --show-sdk-path)

MACOS_FRAMEWORKS_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks
# XCTEST_PATH=$(MACOS_FRAMEWORKS_DIR)/XCTest.framework/XCTest
XCTEST_FLAGS=-F$(MACOS_FRAMEWORKS_DIR) -framework XCTest

CCFLAGS=$(SYSROOT)

compile: compile.dylib

compile.dylib:
	$(CC) \
	  $(CCFLAGS) \
	  $(XCTEST_FLAGS) \
	  -fobjc-arc -shared -undefined dynamic_lookup \
	  -o CustomXCTestRunner.dylib \
	  CustomXCTestRunner.m


