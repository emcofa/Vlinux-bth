#!/usr/bin/env awk

BEGIN {
    FS=","
}
{
    if (NR >= 508 && NR <= 516) { 
        printf("%s %s, %s\n", $1, $2, $3)
    }
}
END {

}
