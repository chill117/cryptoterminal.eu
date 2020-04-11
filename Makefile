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
BUILD_ALL_CSS=$(BUILD)/all.css
SRC=src
CSS=$(SRC)/css
DIST=docs/
IMAGES=$(SRC)/images
PUBLIC=public
PUBLIC_ALL_CSS=$(PUBLIC)/css/all.css
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

CSS_FILES=$(CSS)/fonts.css\
$(CSS)/reset.css\
$(CSS)/style.css\
$(CSS)/pages/*.css
$(BUILD_ALL_CSS): $(CSS)/
	mkdir -p $$(dirname $@)
	rm -f $(BUILD_ALL_CSS)
	for file in $(CSS_FILES); do \
		echo "/* $$file */" >> $(BUILD_ALL_CSS); \
		cat $$file >> $(BUILD_ALL_CSS); \
		echo "" >> $(BUILD_ALL_CSS); \
	done

$(PUBLIC_ALL_CSS): $(BUILD_ALL_CSS)
	mkdir -p $(PUBLIC)/css/
	cp $(BUILD_ALL_CSS) $(PUBLIC_ALL_CSS)
