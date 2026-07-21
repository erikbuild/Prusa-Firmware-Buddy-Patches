# Power panic AC-fault pullup

Sets an internal pullup on the xBuddy `acFault` pin (PG0). An open power
panic line floats and can read as an active (low) AC fault, redscreening
at boot and firing spurious power panics. The internal pullup holds an
open PG0 high; a connected PSU-side driver overrides the weak pullup, so
behavior on healthy hardware is unchanged.

## Usage

From anywhere inside a Prusa-Firmware-Buddy checkout:

    patches/powerpanic-pullup/apply.sh

Manual equivalent:

    git apply patches/powerpanic-pullup/powerpanic-pullup.patch

## Scope

- xBuddy boards only; the iX and MK3.5 `acFault` lines are untouched
- one word in `src/common/hwio_pindef.h`: `Pull::none` → `Pull::up`

## Validation

No host test exists for a pin constant. Verify by building the firmware
and confirming the printer no longer redscreens at boot with an open
power panic connector; a connected PSU still triggers power panic
normally (its driver overrides the weak pullup).

## Notes

Prepared against release 6.6.2. If a future release rejects the hunk,
find the xBuddy `acFault` line in `src/common/hwio_pindef.h` and change
`Pull::none` to `Pull::up` by hand.
