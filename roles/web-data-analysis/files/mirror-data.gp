set grid
set xdata time
set format x "%Y-%m-%d"
set timefmt "%Y-%m-%d"

set datafile separator ","
set term png size 1600,1200

##
set output "/var/www/html/csv-reports/fedora-all.png"
set title "Fedora+Epel Yum Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:2  title 'epel4' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:3  title 'epel5' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:4  title 'epel6' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:5  title 'epel7' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:6  title 'fed03' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:7  title 'fed04' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:8  title 'fed05' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:9  title 'fed06' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:10 title 'fed07' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:11 title 'fed08' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:12 title 'fed09' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:13 title 'fed10' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:14 title 'fed11' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:15 title 'fed12' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:16 title 'fed13' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:17 title 'fed14' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:18 title 'fed15' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:19 title 'fed16' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:20 title 'fed17' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:21 title 'fed18' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:22 title 'fed19' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:23 title 'fed20' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:24 title 'fed21' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:25 title 'fed22' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:26 title 'fed23' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:27 title 'fed24' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:28 title 'rawhide' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:29 title 'unk_rel' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:30 title 'EPEL' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:50 title 'centos' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:51 title 'rhel' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:31 title 'Fedora' with lines lw 3
unset output

set output "/var/www/html/csv-reports/fedora-and-epel.png"
set title "Fedora Epel Totals Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:30 title 'EPEL' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:31 title 'Fedora' with lines lw 3
unset output

set output "/var/www/html/csv-reports/fedora-daily.png"
set title "Fedora Daily Totals Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:31 title 'Fedora' with lines lw 3
unset output

set output "/var/www/html/csv-reports/fedora-os-all.png"
set title "Fedora OS Yum Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:6  title 'fed03' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:7  title 'fed04' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:8  title 'fed05' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:9  title 'fed06' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:10 title 'fed07' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:11 title 'fed08' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:12 title 'fed09' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:13 title 'fed10' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:14 title 'fed11' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:15 title 'fed12' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:16 title 'fed13' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:17 title 'fed14' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:18 title 'fed15' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:19 title 'fed16' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:20 title 'fed17' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:21 title 'fed18' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:22 title 'fed19' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:23 title 'fed20' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:24 title 'fed21' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:25 title 'fed22' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:26 title 'fed23' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:27 title 'fed24' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:28 title 'rawhide' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:29 title 'unk_rel' with lines lw 3
unset output

set output "/var/www/html/csv-reports/fedora-os-latest.png"
set title "Fedora Selected Versions Unique IPs"
plot ["2013-01-01":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:31 title 'Fedora' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:21 title 'fed18' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:22 title 'fed19' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:23 title 'fed20' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:24 title 'fed21' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:25 title 'fed22' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:26 title 'fed23' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:27 title 'fed24' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:28 title 'rawhide' with lines lw 3
unset output

set output "/var/www/html/csv-reports/fedora-os-latest-stacked.png"
set title "Fedora Selected Versions Unique IPs"
plot ["2013-01-01":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:31 title 'Fedora' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($21+$22+$23+$24+$25+$26+$27+$28) title 'fed18' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($22+$23+$24+$25+$26+$27+$28) title 'fed19' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($23+$24+$25+$26+$27+$28) title 'fed20' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($24+$25+$26+$27+$28) title 'fed21' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($25+$26+$27+$28) title 'fed22' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($26+$27+$28) title 'fed23' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($27+$28) title 'fed24' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($28) title 'rawhide' with filledcurves x1
unset output

set output "/var/www/html/csv-reports/fedora-hardware-full.png"
set title "Fedora Hardware via Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:32 title 'alpha' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:33 title 'ARM' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:34 title 'ARM64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:35 title 'ia64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:36 title 'mips' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:48 title 'ppc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:38 title 's390' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:39 title 'sparc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:40 title 'tilegx' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:44 title 'x86_32' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:46 title 'x86_64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:49 title 'unknown' with lines lw 3
unset output

set output "/var/www/html/csv-reports/fedora-hardware-2nd.png"
set title "Fedora Secondary via Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:32 title 'alpha' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:33 title 'ARM' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:34 title 'ARM64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:35 title 'ia64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:36 title 'mips' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:48 title 'ppc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:38 title 's390' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:39 title 'sparc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:40 title 'tilegx' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:49 title 'unknown' with lines lw 3
unset output

set output "/var/www/html/csv-reports/fedora-epel-stacked.png"
set title "Fedora Yum Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29) title 'unknown_rel' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'rawhide' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)      title 'fed24' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26)      title 'fed23' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25)      title 'fed22' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24)          title 'fed21' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23)              title 'fed20' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22)                  title 'fed19' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)                      title 'fed18' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20)                          title 'fed17' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19)                              title 'fed16' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18)                                  title 'fed15' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17)                                      title 'fed14' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16)                                          title 'fed13' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15)                                              title 'fed12' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14)                                                  title 'fed11' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13)                                                      title 'fed10' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12)                                                          title 'fed09' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11)                                                              title 'fed08' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10)                                                                  title 'fed07' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9)                                                                      title 'fed06' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7+$8)                                                                         title 'fed05' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6+$7)                                                                            title 'fed04' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5+$6)                                                                               title 'fed03' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5)                                                                                  title 'epel7' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4)                                                                                     title 'epel6' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3)                                                                                        title 'epel5' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2)                                                                                           title 'epel4' w filledcurves x1
unset output


set output "/var/www/html/csv-reports/fedora-stacked.png"
set title "Fedora Epel Yum Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29)  title 'unknown_rel' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'rawhide' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)  title 'f24' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26)  title 'f23' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25)  title 'f22' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24)  title 'fed21' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23)  title 'fed20' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22)  title 'fed19' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)  title 'fed18' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20)  title 'fed17' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19)  title 'fed16' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18)  title 'fed15' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17)  title 'fed14' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16)  title 'fed13' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15)  title 'fed12' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14)  title 'fed11' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13)  title 'fed10' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12)  title 'fed09' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11)  title 'fed08' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10)  title 'fed07' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9)  title 'fed06' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8)  title 'fed05' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7)  title 'fed04' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6)  title 'fed03' w filledcurves x1
unset output

set output "/var/www/html/csv-reports/fedora-select-stacked.png"
set title "Fedora Epel Yum Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29)  title 'unknown_rel' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'rawhide' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)  title 'fed18-24' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20)  title 'fed12-17' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14)  title 'fed08-11' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($6+$7+$8+$9+$10)  title 'fed03-07' w filledcurves x1
unset output

##
## EPEL
##

set output "/var/www/html/csv-reports/epel-all.png"
set title "Epel Yum Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:2  title 'epel4' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:3  title 'epel5' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:4  title 'epel6' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:5  title 'epel7' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:30 title 'EPEL' with lines lw 3
unset output


set output "/var/www/html/csv-reports/epel-arch.png"
set title "Epel Yum Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:43  title 'x86_32' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:45  title 'x86_64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:47  title 'ppc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:30 title 'EPEL' with lines lw 3
unset output

set output "/var/www/html/csv-reports/epel-stacked.png"
set title "Epel Yum Unique IPs"
plot ["2007-05-17":"2016-12-31"] \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4+$5)  title 'epel7' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3+$4)     title 'epel6' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2+$3)        title 'epel5' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrordata-all.csv' using 1:($2)           title 'epel4' w filledcurves x1
unset output


# ##
# set output "/var/www/html/csv-reports/fedora-all-mov_avg.png"
# set title "Fedora+Epel Yum Unique IPs (7 day moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:2  title 'epel4' with lines lw 3,\
#      'data-mov_avg.csv' using 1:3  title 'epel5' with lines lw 3,\
#      'data-mov_avg.csv' using 1:4  title 'epel6' with lines lw 3,\
#      'data-mov_avg.csv' using 1:5  title 'epel7' with lines lw 3,\
#      'data-mov_avg.csv' using 1:6  title 'fed03' with lines lw 3,\
#      'data-mov_avg.csv' using 1:7  title 'fed04' with lines lw 3,\
#      'data-mov_avg.csv' using 1:8  title 'fed05' with lines lw 3,\
#      'data-mov_avg.csv' using 1:9  title 'fed06' with lines lw 3,\
#      'data-mov_avg.csv' using 1:10 title 'fed07' with lines lw 3,\
#      'data-mov_avg.csv' using 1:11 title 'fed08' with lines lw 3,\
#      'data-mov_avg.csv' using 1:12 title 'fed09' with lines lw 3,\
#      'data-mov_avg.csv' using 1:13 title 'fed10' with lines lw 3,\
#      'data-mov_avg.csv' using 1:14 title 'fed11' with lines lw 3,\
#      'data-mov_avg.csv' using 1:15 title 'fed12' with lines lw 3,\
#      'data-mov_avg.csv' using 1:16 title 'fed13' with lines lw 3,\
#      'data-mov_avg.csv' using 1:17 title 'fed14' with lines lw 3,\
#      'data-mov_avg.csv' using 1:18 title 'fed15' with lines lw 3,\
#      'data-mov_avg.csv' using 1:19 title 'fed16' with lines lw 3,\
#      'data-mov_avg.csv' using 1:20 title 'fed17' with lines lw 3,\
#      'data-mov_avg.csv' using 1:21 title 'fed18' with lines lw 3,\
#      'data-mov_avg.csv' using 1:22 title 'fed19' with lines lw 3,\
#      'data-mov_avg.csv' using 1:23 title 'fed20' with lines lw 3,\
#      'data-mov_avg.csv' using 1:24 title 'fed21' with lines lw 3,\
#      'data-mov_avg.csv' using 1:25 title 'fed22' with lines lw 3,\
#      'data-mov_avg.csv' using 1:26 title 'fed23' with lines lw 3,\
#      'data-mov_avg.csv' using 1:27 title 'fed24' with lines lw 3,\
#      'data-mov_avg.csv' using 1:28 title 'rawhide' with lines lw 3,\
#      'data-mov_avg.csv' using 1:29 title 'unk_rel' with lines lw 3,\
#      'data-mov_avg.csv' using 1:30 title 'EPEL' with lines lw 3,\
#      'data-mov_avg.csv' using 1:50 title 'centos' with lines lw 3,\
#      'data-mov_avg.csv' using 1:51 title 'rhel' with lines lw 3,\
#      'data-mov_avg.csv' using 1:31 title 'Fedora' with lines lw 3
# unset output


# set output "/var/www/html/csv-reports/fedora-and-epel-mov_avg.png"
# set title "Fedora Epel Totals Unique IPs  (7 days moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:30 title 'EPEL' with lines lw 3,\
#      'data-mov_avg.csv' using 1:31 title 'Fedora' with lines lw 3
# unset output

# set output "/var/www/html/csv-reports/fedora-daily-mov_avg.png"
# set title "Fedora Daily Totals Unique IPs"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:31 title 'Fedora' with lines lw 3
# unset output

# set output "/var/www/html/csv-reports/fedora-os-all-mov_avg.png"
# set title "Fedora OS Yum Unique IPs  (7 days moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:6  title 'fed03' with lines lw 3,\
#      'data-mov_avg.csv' using 1:7  title 'fed04' with lines lw 3,\
#      'data-mov_avg.csv' using 1:8  title 'fed05' with lines lw 3,\
#      'data-mov_avg.csv' using 1:9  title 'fed06' with lines lw 3,\
#      'data-mov_avg.csv' using 1:10 title 'fed07' with lines lw 3,\
#      'data-mov_avg.csv' using 1:11 title 'fed08' with lines lw 3,\
#      'data-mov_avg.csv' using 1:12 title 'fed09' with lines lw 3,\
#      'data-mov_avg.csv' using 1:13 title 'fed10' with lines lw 3,\
#      'data-mov_avg.csv' using 1:14 title 'fed11' with lines lw 3,\
#      'data-mov_avg.csv' using 1:15 title 'fed12' with lines lw 3,\
#      'data-mov_avg.csv' using 1:16 title 'fed13' with lines lw 3,\
#      'data-mov_avg.csv' using 1:17 title 'fed14' with lines lw 3,\
#      'data-mov_avg.csv' using 1:18 title 'fed15' with lines lw 3,\
#      'data-mov_avg.csv' using 1:19 title 'fed16' with lines lw 3,\
#      'data-mov_avg.csv' using 1:20 title 'fed17' with lines lw 3,\
#      'data-mov_avg.csv' using 1:21 title 'fed18' with lines lw 3,\
#      'data-mov_avg.csv' using 1:22 title 'fed19' with lines lw 3,\
#      'data-mov_avg.csv' using 1:23 title 'fed20' with lines lw 3,\
#      'data-mov_avg.csv' using 1:24 title 'fed21' with lines lw 3,\
#      'data-mov_avg.csv' using 1:25 title 'fed22' with lines lw 3,\
#      'data-mov_avg.csv' using 1:26 title 'fed23' with lines lw 3,\
#      'data-mov_avg.csv' using 1:27 title 'fed24' with lines lw 3,\
#      'data-mov_avg.csv' using 1:28 title 'rawhide' with lines lw 3,\
#      'data-mov_avg.csv' using 1:29 title 'unk_rel' with lines lw 3
# unset output

# set output "/var/www/html/csv-reports/fedora-os-latest-mov_avg.png"
# set title "Fedora Selected Versions Unique IPs (7 days moving average)"
# plot ["2014-01-01":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:31 title 'Fedora' with lines lw 3,\
#      'data-mov_avg.csv' using 1:21 title 'fed18' with lines lw 3,\
#      'data-mov_avg.csv' using 1:22 title 'fed19' with lines lw 3,\
#      'data-mov_avg.csv' using 1:23 title 'fed20' with lines lw 3,\
#      'data-mov_avg.csv' using 1:24 title 'fed21' with lines lw 3,\
#      'data-mov_avg.csv' using 1:25 title 'fed22' with lines lw 3,\
#      'data-mov_avg.csv' using 1:26 title 'fed23' with lines lw 3,\
#      'data-mov_avg.csv' using 1:27 title 'fed24' with lines lw 3,\
#      'data-mov_avg.csv' using 1:28 title 'rawhide' with lines lw 3
# unset output

# set output "/var/www/html/csv-reports/fedora-os-latest-stacked-mov_avg.png"
# set title "Fedora Selected Versions Unique IPs (7 days moving average)"
# plot ["2014-01-01":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:31 title 'Fedora' with lines lw 3,\
#      'data-mov_avg.csv' using 1:($21+$22+$23+$24+$25+$26+$27+$28) title 'fed18' with filledcurves x1,\
#      'data-mov_avg.csv' using 1:($22+$23+$24+$25+$26+$27+$28) title 'fed19' with filledcurves x1,\
#      'data-mov_avg.csv' using 1:($23+$24+$25+$26+$27+$28) title 'fed20' with filledcurves x1,\
#      'data-mov_avg.csv' using 1:($24+$25+$26+$27+$28) title 'fed21' with filledcurves x1,\
#      'data-mov_avg.csv' using 1:($25+$26+$27+$28) title 'fed22' with filledcurves x1,\
#      'data-mov_avg.csv' using 1:($26+$27+$28) title 'fed23' with filledcurves x1,\
#      'data-mov_avg.csv' using 1:($27+$28) title 'fed24' with filledcurves x1,\
#      'data-mov_avg.csv' using 1:($28) title 'rawhide' with filledcurves x1
# unset output

# set output "/var/www/html/csv-reports/fedora-hardware-full-mov_avg.png"
# set title "Fedora Hardware via Unique IPs (7 days moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:32 title 'alpha' with lines lw 3,\
#      'data-mov_avg.csv' using 1:33 title 'ARM' with lines lw 3,\
#      'data-mov_avg.csv' using 1:34 title 'ARM64' with lines lw 3,\
#      'data-mov_avg.csv' using 1:35 title 'ia64' with lines lw 3,\
#      'data-mov_avg.csv' using 1:36 title 'mips' with lines lw 3,\
#      'data-mov_avg.csv' using 1:48 title 'ppc' with lines lw 3,\
#      'data-mov_avg.csv' using 1:38 title 's390' with lines lw 3,\
#      'data-mov_avg.csv' using 1:39 title 'sparc' with lines lw 3,\
#      'data-mov_avg.csv' using 1:40 title 'tilegx' with lines lw 3,\
#      'data-mov_avg.csv' using 1:44 title 'x86_32' with lines lw 3,\
#      'data-mov_avg.csv' using 1:46 title 'x86_64' with lines lw 3,\
#      'data-mov_avg.csv' using 1:49 title 'unknown' with lines lw 3
# unset output

# set output "/var/www/html/csv-reports/fedora-hardware-2nd-mov_avg.png"
# set title "Fedora Secondary via Unique IPs (7 days moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:32 title 'alpha' with lines lw 3,\
#      'data-mov_avg.csv' using 1:33 title 'ARM' with lines lw 3,\
#      'data-mov_avg.csv' using 1:34 title 'ARM64' with lines lw 3,\
#      'data-mov_avg.csv' using 1:35 title 'ia64' with lines lw 3,\
#      'data-mov_avg.csv' using 1:36 title 'mips' with lines lw 3,\
#      'data-mov_avg.csv' using 1:48 title 'ppc' with lines lw 3,\
#      'data-mov_avg.csv' using 1:38 title 's390' with lines lw 3,\
#      'data-mov_avg.csv' using 1:39 title 'sparc' with lines lw 3,\
#      'data-mov_avg.csv' using 1:40 title 'tilegx' with lines lw 3,\
#      'data-mov_avg.csv' using 1:49 title 'unknown' with lines lw 3
# unset output

# set output "/var/www/html/csv-reports/fedora-all-stacked-mov_avg.png"
# set title "Fedora Epel Yum Unique IPs  (7 days moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29) title 'unknown_rel' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'rawhide' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)      title 'fed24' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26)      title 'fed23' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25)      title 'fed22' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24)          title 'fed21' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23)              title 'fed20' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22)                  title 'fed19' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)                      title 'fed18' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20)                          title 'fed17' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19)                              title 'fed16' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18)                                  title 'fed15' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17)                                      title 'fed14' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16)                                          title 'fed13' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15)                                              title 'fed12' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14)                                                  title 'fed11' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13)                                                      title 'fed10' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12)                                                          title 'fed09' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11)                                                              title 'fed08' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10)                                                                  title 'fed07' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9)                                                                      title 'fed06' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8)                                                                         title 'fed05' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7)                                                                            title 'fed04' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6)                                                                               title 'fed03' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5)                                                                                  title 'epel7' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4)                                                                                     title 'epel6' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3)                                                                                        title 'epel5' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2)                                                                                           title 'epel4' w filledcurves x1
# unset output

# set output "/var/www/html/csv-reports/fedora-epel-stacked-mov_avg.png"
# set title "Fedora Epel (consolidated) Yum Unique IPs  (7 days moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'unknown_rel' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)      title 'rawhide' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26)          title 'fedora' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5)                                                                                  title 'epel' w filledcurves x1
# unset output

# set output "/var/www/html/csv-reports/fedora-stacked-mov_avg.png"
# set title "Fedora Yum Unique IPs (7 day moving avg)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29)  title 'unknown_rel' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'rawhide' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)  title 'f24' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26)  title 'f23' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25)  title 'f22' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24)  title 'fed21' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23)  title 'fed20' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22)  title 'fed19' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)  title 'fed18' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20)  title 'fed17' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19)  title 'fed16' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18)  title 'fed15' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17)  title 'fed14' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16)  title 'fed13' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15)  title 'fed12' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14)  title 'fed11' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13)  title 'fed10' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12)  title 'fed09' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11)  title 'fed08' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10)  title 'fed07' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9)  title 'fed06' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8)  title 'fed05' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7)  title 'fed04' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6)  title 'fed03' w filledcurves x1
# unset output

# set output "/var/www/html/csv-reports/fedora-select-stacked-mov_avg.png"
# set title "Fedora Epel Yum Unique IPs (7 days moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29)  title 'unknown_rel' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'rawhide' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)  title 'fed18-24' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20)  title 'fed12-17' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14)  title 'fed08-11' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($6+$7+$8+$9+$10)  title 'fed03-07' w filledcurves x1
# unset output

# set output "/var/www/html/csv-reports/epel-all-mov_avg.png"
# set title "Epel Yum Unique IPs (7 days moving average)"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:2  title 'epel4' with lines lw 3,\
#      'data-mov_avg.csv' using 1:3  title 'epel5' with lines lw 3,\
#      'data-mov_avg.csv' using 1:4  title 'epel6' with lines lw 3,\
#      'data-mov_avg.csv' using 1:5  title 'epel7' with lines lw 3,\
#      'data-mov_avg.csv' using 1:30 title 'EPEL' with lines lw 3
# unset output

# set output "/var/www/html/csv-reports/epel-arch-mov_avg.png"
# set title "Epel Yum Unique IPs"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:43  title 'x86_32' with lines lw 3,\
#      'data-mov_avg.csv' using 1:45  title 'x86_64' with lines lw 3,\
#      'data-mov_avg.csv' using 1:47  title 'ppc' with lines lw 3,\
#      'data-mov_avg.csv' using 1:30 title 'EPEL' with lines lw 3
# unset output

# set output "/var/www/html/csv-reports/epel-stacked-mov_avg.png"
# set title "Epel Yum Unique IPs"
# plot ["2007-05-17":"2016-12-31"] \
#      'data-mov_avg.csv' using 1:($2+$3+$4+$5)  title 'epel7' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3+$4)     title 'epel6' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2+$3)        title 'epel5' w filledcurves x1, \
#      'data-mov_avg.csv' using 1:($2)           title 'epel4' w filledcurves x1
# unset output
