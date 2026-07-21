# Boot splash customization kit

Draws a compiled-in image over the bootloader's Prusa logo on the firmware
boot splash and adds a byline beneath the version text. CoreOne family only
(COREONE including the INDX variants, 480x320 display); every other printer
compiles the feature out.

## Usage

From anywhere inside a Prusa-Firmware-Buddy checkout:

    patches/boot-splash/apply.sh

installs the default pony image and "by @erikbuild" byline. To make it your
own:

    patches/boot-splash/apply.sh --image path/to/your.png --text "by @you" --version "6.6.3+1"

Manual equivalent:

    git apply patches/boot-splash/boot-splash.patch
    mkdir -p src/gui/res/splash
    cp your.png src/gui/res/splash/splash_image.png
    # optionally edit the byline string in src/gui/splash_byline.hpp

The patch is code-only: the tree does not build until an image exists at
`src/gui/res/splash/splash_image.png` (the script's job). The build converts
the PNG to QOI and embeds it in the firmware binary — no external flash
dependency — regenerating whenever the PNG changes. Python deps (pillow,
qoi, numpy) are stock `requirements.txt` entries.

## Image constraints

- PNG, at most 480 wide and 157 tall (drawn at y=8, must clear the progress
  bar at y=165 — a static_assert enforces this at compile time)
- transparent pixels composite against the black splash background, so
  flatten transparency on black before converting
- byline text: plain characters only, no quotes or backslashes

## Version

`--version "X.Y.Z+N"` writes the string to `version.txt`; the patched build
uses the `+N` as `BUILD_NUMBER` (an explicit `-D BUILD_NUMBER=` still wins,
and a `version.txt` without `+N` keeps stock git-count behavior). Pick `N`
above the installed firmware's build number so the bootloader auto-offers
the built `.bbf`.

## Validation

Build the CoreOne firmware as usual, and run the host unit test:

    python3 utils/build_tests.py memory_byte_reader_tests -t -- -R MemoryByteReader

(On macOS the host tests additionally need `patches/macos-host-unit-tests.patch`
and a GNU GCC, e.g. Homebrew gcc.)

## Notes

- The Prusa logo still flashes briefly at power-on: the closed-source
  bootloader draws it before firmware runs. Firmware paints over it; this
  kit cannot prevent the flash.
- Prepared against release 6.6.2. On a future release, if `git apply`
  rejects hunks, the new files always apply; only the small context edits
  (two CMakeLists source lists, screen_splash.cpp/.hpp) may need manual
  replay. See the patch header for the full list.
