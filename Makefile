CXX = clang++
CXXFLAGS = -std=c++17 -Wall -Wextra -I Sources/Cpp/include
SRC_DIR = Sources/Cpp/src
TEST_DIR = Tests
BUILD_DIR = build

.PHONY: all test clean

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/color_tests: $(SRC_DIR)/ColorUtils.cpp $(TEST_DIR)/ColorUtilsTests.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(BUILD_DIR)/layout_tests: $(SRC_DIR)/LayoutEngine.cpp $(TEST_DIR)/LayoutEngineTests.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^

test: $(BUILD_DIR)/color_tests $(BUILD_DIR)/layout_tests
	./$(BUILD_DIR)/color_tests
	./$(BUILD_DIR)/layout_tests

clean:
	rm -rf $(BUILD_DIR)
