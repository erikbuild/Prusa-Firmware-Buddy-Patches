# G751 squiggly purge

Port of the Klipper community "squiggly purge" macro as custom G-code
G751: a cosine-wave prime line with flow-derived line width/feedrate and
adaptive placement near the print area (from the M555 print-area rect that
stock PrusaSlicer start G-code already sends). Scoped to the non-INDX
CoreOne family (COREONE incl. Core One+, COREONEL); INDX builds exclude it
entirely.

## Usage

From anywhere inside a Prusa-Firmware-Buddy checkout:

    patches/g751-squiggly-purge/apply.sh

Manual equivalent:

    git apply patches/g751-squiggly-purge/g751-squiggly-purge.patch

In slicer start G-code (replaces the stock purge-line block):

    G751 [L purge mm] [Q mm3/s] [A amplitude] [W wavelength] [P periods]
         [S steps/period] [H line height] [U unretract] [D 0=X/1=Y]
         [X/Y start override] [C adaptive 0/1] [M margin] [B max cross-section mm2]

## Validation

Build the test target first, then run it (the `-t` flag skips building):

    python3 utils/build_tests.py squiggly_purge_tests
    python3 utils/build_tests.py squiggly_purge_tests -t -- -R squiggly_purge

## Notes

Prepared against release 6.6.2. If a future release rejects hunks, the new
files (src/feature/squiggly_purge/*, src/marlin_stubs/G751.cpp,
tests/unit/feature/squiggly_purge/*) always apply; only the four small
context edits (two CMakeLists source lists, PrusaGcodeSuite.hpp
declaration, gcode.cpp dispatch case) may need manual replay. Check that
upstream has not claimed G-code number 751.
