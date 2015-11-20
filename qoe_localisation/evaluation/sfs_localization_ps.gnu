#!/usr/bin/gnuplot
#
# AUTHOR: Hagen Wierstorf

reset
set macros
set loadpath '../data'

set terminal pdfcairo size 15cm,18cm color

load 'localization.cfg'
load 'array.cfg'

set style line 101 lc rgb '#808080' lt 1 lw 1

unset key
set size ratio -1


set cbrange [0:40]

set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0

unset colorbox
unset tics
unset xlabel
unset ylabel
set border 0

set xrange [-2.1:2.1]
set yrange [-1.7:3.1]



WFS_PS = 'human_label_localization_wfs_ps_circular'
WFS_FS = 'human_label_localization_wfs_fs_circular'
WFS_PW = 'human_label_localization_wfs_pw_circular'
NFCHOA_PS = 'human_label_localization_nfchoa_ps_circular'
NFCHOA_PW = 'human_label_localization_nfchoa_pw_circular'
WFS_LINEAR = 'human_label_localization_wfs_ps_linear'


# --- WFS circular array, point source -----------------------------------
set output 'localization_wfs_circular_ps.pdf'
set multiplot layout 3,3

# --- 1,1 ---
# WFS point source, 56 secondary sources
set arrow 21 from 1.210,1.194 to 1.322,1.069 heads size 0.05,90,0 front ls 101
set label 21 '0.17m' at 1.452,1.298 rotate by -48.21 front center tc ls 101
set label 31 'Human Label' at 0,2.9 center front
plot WFS_PS.'.csv' i 2                  @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset arrow 21
unset label 21

# --- 1,2 ---
# WFS point source, 56 secondary sources, Dietz model
set label 31 'Wierstorf (2014)'
plot WFS_PS.'_dietz.csv' i 2            @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 

# --- 1,3 ---
# WFS point source, 56 secondary sources, Two!Ears model
set label 31 'Two!Ears'
plot WFS_PS.'_twoears.csv' i 2          @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset label 31


# --- 2,1 ---
# WFS point source, 28 secondary sources
set arrow 21 from 1.077,1.314 to 1.314,1.077 heads size 0.05,90,0 front ls 101
set label 21 '0.34m' at 1.372,1.372 rotate by -45 front center tc ls 101
plot WFS_PS.'.csv' i 1                  @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 2,2 ---
# WFS point source, 28 secondary sources, Dietz model
plot WFS_PS.'_dietz.csv' i 1            @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 2,3 ---
# WFS point source, 28 secondary sources, Two!Ears model
plot WFS_PS.'_twoears.csv' i 1          @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,1 ---
# WFS point source, 14 secondary sources
set arrow 21 from 0.421,1.643 to 1.022,1.353 heads size 0.05,90,0 front ls 101
set label 21 '0.67m' at 0.823,1.723 rotate by -25.71 front center tc ls 101
plot WFS_PS.'.csv' i 0                  @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 3,2 ---
# WFS point source, 14 secondary sources, Dietz model
plot WFS_PS.'_dietz.csv' i 0            @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,3 ---
# WFS point source, 14 secondary sources, Two!Ears model
plot WFS_PS.'_twoears.csv' i 0          @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

unset multiplot


# --- WFS circular array, plane wave -------------------------------------
set output 'localization_wfs_circular_pw.pdf'
set multiplot layout 3,3

# --- 1,1 ---
# WFS plane wave, 56 secondary sources
set arrow 21 from 1.210,1.194 to 1.322,1.069 heads size 0.05,90,0 front ls 101
set label 21 '0.17m' at 1.452,1.298 rotate by -48.21 front center tc ls 101
set label 31 'Human Label' at 0,2.9 center front
plot WFS_PW.'.csv' i 2                  @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset arrow 21
unset label 21

# --- 1,2 ---
# WFS plane wave, 56 secondary sources, Dietz model
set label 31 'Wierstorf (2014)'
plot WFS_PW.'_dietz.csv' i 2            @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 

# --- 1,3 ---
# WFS plane wave, 56 secondary sources, Two!Ears model
set label 31 'Two!Ears'
plot WFS_PW.'_twoears.csv' i 2          @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset label 31


# --- 2,1 ---
# WFS plane wave, 28 secondary sources
set arrow 21 from 1.077,1.314 to 1.314,1.077 heads size 0.05,90,0 front ls 101
set label 21 '0.34m' at 1.372,1.372 rotate by -45 front center tc ls 101
plot WFS_PW.'.csv' i 1                  @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 2,2 ---
# WFS plane wave, 28 secondary sources, Dietz model
plot WFS_PW.'_dietz.csv' i 1            @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 2,3 ---
# WFS plane wave, 28 secondary sources, Two!Ears model
plot WFS_PW.'_twoears.csv' i 1          @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,1 ---
# WFS plane wave, 14 secondary sources
set arrow 21 from 0.421,1.643 to 1.022,1.353 heads size 0.05,90,0 front ls 101
set label 21 '0.67m' at 0.823,1.723 rotate by -25.71 front center tc ls 101
plot WFS_PW.'.csv' i 0                  @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 3,2 ---
# WFS plane wave, 14 secondary sources, Dietz model
plot WFS_PW.'_dietz.csv' i 0            @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,3 ---
# WFS plane wave, 14 secondary sources, Two!Ears model
plot WFS_PW.'_twoears.csv' i 0          @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

unset multiplot


# --- WFS circular array, focused source ---------------------------------
set output 'localization_wfs_circular_fs.pdf'
set multiplot layout 3,3

# --- 1,1 ---
# WFS focused source, 56 secondary sources
set arrow 21 from 1.210,1.194 to 1.322,1.069 heads size 0.05,90,0 front ls 101
set label 21 '0.17m' at 1.452,1.298 rotate by -48.21 front center tc ls 101
set label 31 'Human Label' at 0,2.9 center front
plot WFS_FS.'.csv' i 2                  @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset arrow 21
unset label 21

# --- 1,2 ---
# WFS focused source, 56 secondary sources, Dietz model
set label 31 'Wierstorf (2014)'
plot WFS_FS.'_dietz.csv' i 2            @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 

# --- 1,3 ---
# WFS focused source, 56 secondary sources, Two!Ears model
set label 31 'Two!Ears'
plot WFS_FS.'_twoears.csv' i 2          @localization_arrow,\
     'array_nls56_circular.txt'         @array_inactive w p,\
     'array_nls56_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset label 31


# --- 2,1 ---
# WFS focused source, 28 secondary sources
set arrow 21 from 1.077,1.314 to 1.314,1.077 heads size 0.05,90,0 front ls 101
set label 21 '0.34m' at 1.372,1.372 rotate by -45 front center tc ls 101
plot WFS_FS.'.csv' i 1                  @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 2,2 ---
# WFS focused source, 28 secondary sources, Dietz model
plot WFS_FS.'_dietz.csv' i 1            @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 2,3 ---
# WFS focused source, 28 secondary sources, Two!Ears model
plot WFS_FS.'_twoears.csv' i 1          @localization_arrow,\
     'array_nls28_circular.txt'         @array_inactive w p,\
     'array_nls28_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,1 ---
# WFS focused source, 14 secondary sources
set arrow 21 from 0.421,1.643 to 1.022,1.353 heads size 0.05,90,0 front ls 101
set label 21 '0.67m' at 0.823,1.723 rotate by -25.71 front center tc ls 101
plot WFS_FS.'.csv' i 0                  @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 3,2 ---
# WFS focused source, 14 secondary sources, Dietz model
plot WFS_FS.'_dietz.csv' i 0            @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,3 ---
# WFS focused source, 14 secondary sources, Two!Ears model
plot WFS_FS.'_twoears.csv' i 0          @localization_arrow,\
     'array_nls14_circular.txt'         @array_inactive w p,\
     'array_nls14_circular_wfs_ps.txt'  @array_active w p,\
     set_point_source(0,2.5)            @point_source

unset multiplot


# ----- NFC-HOA point source ---------------------------------------------
set output 'localization_nfchoa_circular_ps.pdf'

set multiplot layout 3,3

# --- 1,1 ---
# NFC-HOA point source, 56 secondary sources
set arrow 21 from 1.210,1.194 to 1.322,1.069 heads size 0.05,90,0 front ls 101
set label 21 '0.17m' at 1.452,1.298 rotate by -48.21 front center tc ls 101
set label 31 'Human Label' at 0,2.9 center front
plot NFCHOA_PS.'.csv' i 3               @localization_arrow,\
     'array_nls56_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset arrow 21
unset label 21

# --- 1,2 ---
# NFCHOA point source, 56 secondary sources, Dietz model
set label 31 'Wierstorf (2014)'
plot NFCHOA_PS.'_dietz.csv' i 3         @localization_arrow,\
     'array_nls56_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source 

# --- 1,3 ---
# NFCHOA point source, 56 secondary sources, Two!Ears model
set label 31 'Two!Ears'
plot NFCHOA_PS.'_twoears.csv' i 3       @localization_arrow,\
     'array_nls56_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset label 31


# --- 2,1 ---
# NFCHOA point source, 28 secondary sources
set arrow 21 from 1.077,1.314 to 1.314,1.077 heads size 0.05,90,0 front ls 101
set label 21 '0.34m' at 1.372,1.372 rotate by -45 front center tc ls 101
plot NFCHOA_PS.'.csv' i 2               @localization_arrow,\
     'array_nls28_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 2,2 ---
# NFCHOA point source, 28 secondary sources, Dietz model
plot NFCHOA_PS.'_dietz.csv' i 2         @localization_arrow,\
     'array_nls28_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 2,3 ---
# NFCHOA point source, 28 secondary sources, Two!Ears model
plot NFCHOA_PS.'_twoears.csv' i 2       @localization_arrow,\
     'array_nls28_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,1 ---
# NFCHOA point source, 14 secondary sources
set arrow 21 from 0.421,1.643 to 1.022,1.353 heads size 0.05,90,0 front ls 101
set label 21 '0.67m' at 0.823,1.723 rotate by -25.71 front center tc ls 101
plot NFCHOA_PS.'.csv' i 1               @localization_arrow,\
     'array_nls14_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 3,2 ---
# NFCHOA point source, 14 secondary sources, Dietz model
plot NFCHOA_PS.'_dietz.csv' i 1         @localization_arrow,\
     'array_nls14_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,3 ---
# NFCHOA point source, 14 secondary sources, Two!Ears model
plot NFCHOA_PS.'_twoears.csv' i 1       @localization_arrow,\
     'array_nls14_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source

unset multiplot


# ----- NFC-HOA plane wave ---------------------------------------------
set output 'localization_nfchoa_circular_pw.pdf'

set multiplot layout 3,3

# --- 1,1 ---
# NFC-HOA plane wave, 56 secondary sources
set arrow 21 from 1.210,1.194 to 1.322,1.069 heads size 0.05,90,0 front ls 101
set label 21 '0.17m' at 1.452,1.298 rotate by -48.21 front center tc ls 101
set label 31 'Human Label' at 0,2.9 center front
plot NFCHOA_PW.'.csv' i 3               @localization_arrow,\
     'array_nls56_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset arrow 21
unset label 21

# --- 1,2 ---
# NFCHOA plane wave, 56 secondary sources, Dietz model
set label 31 'Wierstorf (2014)'
plot NFCHOA_PW.'_dietz.csv' i 3         @localization_arrow,\
     'array_nls56_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source 

# --- 1,3 ---
# NFCHOA plane wave, 56 secondary sources, Two!Ears model
set label 31 'Two!Ears'
plot NFCHOA_PW.'_twoears.csv' i 3       @localization_arrow,\
     'array_nls56_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source 
unset label 31


# --- 2,1 ---
# NFCHOA plane wave, 28 secondary sources
set arrow 21 from 1.077,1.314 to 1.314,1.077 heads size 0.05,90,0 front ls 101
set label 21 '0.34m' at 1.372,1.372 rotate by -45 front center tc ls 101
plot NFCHOA_PW.'.csv' i 2               @localization_arrow,\
     'array_nls28_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 2,2 ---
# NFCHOA plane wave, 28 secondary sources, Dietz model
plot NFCHOA_PW.'_dietz.csv' i 2         @localization_arrow,\
     'array_nls28_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 2,3 ---
# NFCHOA plane wave, 28 secondary sources, Two!Ears model
plot NFCHOA_PW.'_twoears.csv' i 2       @localization_arrow,\
     'array_nls28_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,1 ---
# NFCHOA plane wave, 14 secondary sources
set arrow 21 from 0.421,1.643 to 1.022,1.353 heads size 0.05,90,0 front ls 101
set label 21 '0.67m' at 0.823,1.723 rotate by -25.71 front center tc ls 101
plot NFCHOA_PW.'.csv' i 1               @localization_arrow,\
     'array_nls14_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source
unset arrow 21
unset label 21

# --- 3,2 ---
# NFCHOA plane wave, 14 secondary sources, Dietz model
plot NFCHOA_PW.'_dietz.csv' i 1         @localization_arrow,\
     'array_nls14_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source

# --- 3,3 ---
# NFCHOA plane wave, 14 secondary sources, Two!Ears model
plot NFCHOA_PW.'_twoears.csv' i 1       @localization_arrow,\
     'array_nls14_circular.txt'         @array_active w p,\
     set_point_source(0,2.5)            @point_source

unset multiplot

# --- WFS linear array -------------------------------------------------
set xrange [-2.1:2.1]
set yrange [-2.3:1.3]

set output 'localization_wfs_linear_ps.pdf'
set multiplot layout 3,3

# --- 1,1 ---
# WFS point source, 15 secondary sources
#set arrow 21 from 1.210,1.194 to 1.322,1.069 heads size 0.05,90,0 front ls 101
#set label 21 '0.17m' at 1.452,1.298 rotate by -48.21 front center tc ls 101
set label 31 'Human Label' at 0,1.4 center front
plot WFS_LINEAR.'.csv' i 0              @localization_arrow,\
     'array_nls15_linear.txt'           @array_active w p,\
     set_point_source(0,1)              @point_source 
#unset arrow 21
#unset label 21

# --- 1,2 ---
# WFS point source, 15 secondary sources, Dietz model
set label 31 'Wierstorf (2014)'
plot WFS_LINEAR.'_dietz.csv' i 0        @localization_arrow,\
     'array_nls15_linear.txt'           @array_active w p,\
     set_point_source(0,1)              @point_source 

# --- 1,3 ---
# WFS point source, 15 secondary sources, Two!Ears model
set label 31 'Two!Ears'
plot WFS_LINEAR.'_twoears.csv' i 0      @localization_arrow,\
     'array_nls15_linear.txt'           @array_active w p,\
     set_point_source(0,1)              @point_source 
unset label 31


# --- 2,1 ---
# WFS point source, 8 secondary sources
#set arrow 21 from 1.077,1.314 to 1.314,1.077 heads size 0.05,90,0 front ls 101
#set label 21 '0.34m' at 1.372,1.372 rotate by -45 front center tc ls 101
plot WFS_LINEAR.'.csv' i 2              @localization_arrow,\
     'array_nls8_linear.txt'            @array_active w p,\
     set_point_source(0,1)              @point_source
#unset arrow 21
#unset label 21

# --- 2,2 ---
# WFS point source, 8 secondary sources, Dietz model
plot WFS_LINEAR.'_dietz.csv' i 2        @localization_arrow,\
     'array_nls8_linear.txt'            @array_active w p,\
     set_point_source(0,1)              @point_source

# --- 2,3 ---
# WFS point source, 8 secondary sources, Two!Ears model
plot WFS_LINEAR.'_twoears.csv' i 2      @localization_arrow,\
     'array_nls8_linear.txt'            @array_active w p,\
     set_point_source(0,1)              @point_source

# --- 3,1 ---
# WFS point source, 3 secondary sources
#set arrow 21 from 0.421,1.643 to 1.022,1.353 heads size 0.05,90,0 front ls 101
#set label 21 '0.67m' at 0.823,1.723 rotate by -25.71 front center tc ls 101
plot WFS_LINEAR.'.csv' i 1              @localization_arrow,\
     'array_nls3_linear.txt'            @array_active w p,\
     set_point_source(0,1)              @point_source
#unset arrow 21
#unset label 21

# --- 3,2 ---
# WFS point source, 3 secondary sources, Dietz model
plot WFS_LINEAR.'_dietz.csv' i 1        @localization_arrow,\
     'array_nls3_linear.txt'            @array_active w p,\
     set_point_source(0,1)              @point_source

# --- 3,3 ---
# WFS point source, 3 secondary sources, Two!Ears model
plot WFS_LINEAR.'_twoears.csv' i 1      @localization_arrow,\
     'array_nls3_linear.txt'            @array_active w p,\
     set_point_source(0,1)              @point_source

unset multiplot


