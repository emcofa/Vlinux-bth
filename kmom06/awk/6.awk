#!/usr/bin/env awk

#rader hamnar ej rätt

BEGIN {
    FS=","
    printf("%-10s\t%-10s\t%20s", "Förnamn", "Efternamn", "Stad")
    print "\n----------------------------------------------------\n"
}
{
    if ($3 ~ /stad/) {
        if ($4 ~ /-01-/ || $4 ~ /-10-/) {
            printf("%-10s\t%-10s\t%20s\n", $1, $2, $3)
        }
    }

}
END {

    print "\n-----------------------------------------------------\n"
}