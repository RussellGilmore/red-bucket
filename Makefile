# Makefile

# Define the target folder
TARGET_FOLDER := site

# Define the files to be created
HTML_FILE := $(TARGET_FOLDER)/index.html
CSS_FILE := $(TARGET_FOLDER)/styles.css
JS_FILE := $(TARGET_FOLDER)/scripts.js

# Default target
all: $(HTML_FILE) $(CSS_FILE) $(JS_FILE)

# Rule to create the target folder
$(TARGET_FOLDER):
	mkdir -p $(TARGET_FOLDER)

# Rule to create the index.html file
$(HTML_FILE): $(TARGET_FOLDER)
	echo "<html><head><title>My Website</title></head><body><h1>Welcome to my website!</h1></body></html>" > $(HTML_FILE)

# Rule to create the styles.css file
$(CSS_FILE): $(TARGET_FOLDER)
	touch $(CSS_FILE)

# Rule to create the scripts.js file
$(JS_FILE): $(TARGET_FOLDER)
	touch $(JS_FILE)

# Clean target
clean:
	rm -rf $(TARGET_FOLDER)
