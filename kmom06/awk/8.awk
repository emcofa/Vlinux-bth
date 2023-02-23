#!/usr/bin/env awk

BEGIN {
    FS=","
    OFS="\t"
}
{
    if (NR > 1) {
        split($4, items, "-")
        counter=items[3]++
        if (length(counter) < 2) {
            counter="0"counter
        }
        if (match($5, counter)) {
            printf("%s %s, %s, %s\n", $1, $2, $4, $5)
        }
    }

}
END {
    print "\n---------------------------------\n"
}
