#!/bin/bash

# Remove warnings on stderr about missing configuration and used default rules.

SEDSCRIPT='
0,/^WARN: No configuration file found at/{/^WARN: No configuration file found at/d;};
1,/^WARN: Using example .* found at/{/^WARN: Using example .* found at/d;};
'

exec ansible-review "$@" 2> >(sed -e "$SEDSCRIPT" >&2)
