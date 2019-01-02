## Usage
#
#   $ npm install
#
# And then you can run various commands:
#
#   $ make            # compile files that need compiling
#   $ make clean all  # remove target files and recompile from scratch
#

## Variables
BIN=node_modules/.bin
BUILD=build
BUILD_ALL_CSS=$(BUILD)/all.min.css
SRC=src
CSS=$(SRC)/css
DIST=docs/
IMAGES=$(SRC)/images
PUBLIC=public
PUBLIC_ALL_CSS=$(PUBLIC)/css/all.min.css
SCRIPTS=scripts

# Targets
#
# The format goes:
#
#   target: list of dependencies
#     commands to build target
#
# If something isn't re-compiling double-check the changed file is in the
# target's dependencies list.

# Phony targets - these are for when the target-side of a definition
# (such as "all" below) isn't a file but instead a just label. Declaring
# it as phony ensures that it always run, even if a file by the same name
# exists.
.PHONY: all clean commit copy

all: $(PUBLIC_ALL_CSS) copy

clean:
	# Delete build and output files:
	rm -rf $(BUILD) $(PUBLIC)

commit:
	rm -rf $(DIST)/
	cp -r $(PUBLIC) $(DIST);
	git add $(DIST);
	git commit $(DIST);

copy:
	# Fonts:
	mkdir -p $(PUBLIC)/fonts/OpenSans
	cp -r node_modules/open-sans-fontface/fonts/**/* $(PUBLIC)/fonts/OpenSans/
	# Images:
	mkdir -p $(PUBLIC)/images/
	cp -r $(IMAGES)/* $(PUBLIC)/images/
	# HTML files:
	cp -r $(SRC)/*.html $(PUBLIC)/

$(BUILD)/css/*.min.css: $(CSS)/*.css
	mkdir -p $(BUILD)/css
	$(BIN)/postcss $^ --ext .min.css --dir $(BUILD)/css

$(BUILD)/css/pages/*.min.css: $(CSS)/pages/*.css
	mkdir -p $(BUILD)/css/pages
	$(BIN)/postcss $^ --ext .min.css --dir $(BUILD)/css/pages

CSS_FILES=$(CSS)/fonts.css\
$(CSS)/reset.css\
$(CSS)/style.css\
$(CSS)/pages/*.css
CSS_MIN_FILES=$(subst $(SRC)/, $(BUILD)/, $(patsubst %.css, %.min.css, $(CSS_FILES)))
$(BUILD_ALL_CSS): $(BUILD)/css/*.min.css $(BUILD)/css/pages/*.min.css
	rm -f $(BUILD_ALL_CSS)
	for file in $(CSS_MIN_FILES); do \
		cat $$file >> $(BUILD_ALL_CSS); \
		echo "" >> $(BUILD_ALL_CSS); \
	done

$(PUBLIC_ALL_CSS): $(BUILD_ALL_CSS)
	mkdir -p $(PUBLIC)/css/
	cp $(BUILD_ALL_CSS) $(PUBLIC_ALL_CSS)
