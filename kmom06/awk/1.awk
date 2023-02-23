#!/usr/bin/env awk

BEGIN {
    FS=","
}
{
    if (NR > 1) { 
        print $1, $2
    }
}
END {

}