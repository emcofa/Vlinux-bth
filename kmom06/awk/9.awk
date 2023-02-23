#!/usr/bin/env awk

BEGIN {
    FS=","
    OFS="\t"
    counter=0
}
{   
    if (NR > 1) {
        split($4, items, "-")
        dayOfMonth=items[3]++
        year=items[1]++
        if (length(dayOfMonth) < 2) {
            dayOfMonth="0"dayOfMonth
        }
        if (year < 2000 && match($5, dayOfMonth)) {
            counter++
        }
        if (match($5, dayOfMonth)) {
            printf("%s %s, %s, %s\n", $1, $2, $4, $5)
        }
    }

}
END {
    print "---------------------------------"
    printf ("%s stycken är födda innan år 2000.\n", counter)
}
