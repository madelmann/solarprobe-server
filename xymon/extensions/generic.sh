#!/bin/sh

COLUMN=${1}    # Name of the column
COLOR=${2}     # By default, everything is OK
MSG=${3}

# Do whatever you need to test for something
# As an example, go red if /tmp/badstuff exists.
if test -f /tmp/badstuff
then
    COLOR=red
    MSG="${MSG}

    $(cat /tmp/badstuff)
    "
else
    MSG="${MSG}

    All is OK
    "
fi

# Tell Xymon about it
#echo "$XYMON $XYMONSRV status $MACHINE.$COLUMN $COLOR $(date)
#
#${MSG}
#"

echo "$COLUMN $COLOR $(date)"

exit 0
