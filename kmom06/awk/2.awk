#!/usr/bin/env awk

BEGIN {
    FS=","
}
{
    if (NR <= 101 && NR > 1) { 
        printf("%s %s, %s\n", $1, $2, $3)
    }
}
END {

}