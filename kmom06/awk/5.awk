#!/usr/bin/env awk

#rader hamnar ej rätt
BEGIN {
    FS=","
    # OFS="\t"
    printf("%-10s\t%-10s\t%20s", "Förnamn", "Efternamn", "Stad")
    print "\n----------------------------------------------------\n"
}
NR==1 { next }
{   

    if ($3 ~ /berg$/) {
        printf("%-10s\t%-10s\t%20s\n", $1, $2, $3)
    }
}
END {
    print "\n-----------------------------------------------------\n"
}