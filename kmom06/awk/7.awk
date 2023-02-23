#!/usr/bin/env awk

BEGIN {
    FS=","
    OFS="\t"
    printf("%s\t%s", "Årtal", "Antal")
    print "\n-------------"
}
{
    if (NR > 1) {
        split($4, items, "-")
        data[items[1]]++
    }
}
END {

    for (item in data) {
        printf("%s\t%5s\n", item, data[item])
    }
    print "\n-------------\n"
}
