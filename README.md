# Patches

Reusable modifications for Prusa-Firmware-Buddy source trees, prepared
against release 6.6.2 and intended to carry customizations forward onto
future releases. Each kit directory contains a self-documenting patch (a
prose header above the diff), an `apply.sh`, and a README with full
details; the patches touch disjoint files, so they can be applied in any
order and in any combination.

## boot-splash/

Draws a compiled-in image over the bootloader's Prusa logo on the boot
splash, adds a byline beneath the version text, and can pin the firmware
version/build number so the bootloader auto-offers the built `.bbf`.
CoreOne family only (including INDX variants); other printers compile the
feature out.

    patches/boot-splash/apply.sh [--image your.png] [--text "by @you"] [--version "X.Y.Z+N"]

Defaults: the kit's pony image and "by @erikbuild". Image constraints
(size, transparency) are in the kit README.

## powerpanic-pullup/

Sets an internal pullup on the xBuddy `acFault` pin so an open power panic
line no longer redscreens at boot or fires spurious power panics; healthy
hardware is unaffected (the PSU-side driver overrides the weak pullup).

    patches/powerpanic-pullup/apply.sh

## g751-squiggly-purge/

Custom G-code G751: a cosine-wave prime line with flow-derived line
width/feedrate and adaptive placement near the print area — a port of the
Klipper community "squiggly purge" macro. Called from slicer start G-code
in place of the stock purge-line block. Non-INDX CoreOne family only;
INDX builds exclude it entirely.

    patches/g751-squiggly-purge/apply.sh

## Applying everything

A fully customized tree from a fresh source drop:

    patches/powerpanic-pullup/apply.sh
    patches/g751-squiggly-purge/apply.sh
    patches/boot-splash/apply.sh --image me.png --text "by @me" --version "6.6.4+2"

Then build as usual (e.g. `utils/build.py --preset coreone_indx
--build-type release --bootloader yes`). Which features are active is
decided per printer at compile time — an INDX build takes the splash and
pullup but excludes G751 automatically.

Each `apply.sh` refuses to run on a tree where its patch is already
applied and validates its inputs before touching anything — a failed
apply leaves the tree unchanged. If a future release rejects hunks, each
patch's prose header lists exactly which context edits may need manual
replay.
