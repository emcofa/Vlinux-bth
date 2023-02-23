#!/usr/bin/env awk

BEGIN {
    FS=","
    printf("%-10s\t %-18s\t%s\t\n", "Förnamn", "Efternamn", "Telefonnummer")
    print "-----------------------------------------------------"
}
NR==1 { next }
{
    printf("%-10s\t %-18s\t %-10s\t\n", $1, $2, $5)
}
END {
    print "\n---------------------------------------------------\n"
}