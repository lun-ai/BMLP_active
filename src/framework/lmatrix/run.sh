#!/bin/bash

trap '' HUP INT

############################## To call ##############################
# bash framework/lmatrix/run.sh experiments/networks/connection

############################## flight routes ####################################
method=$2

for k in 1000
do
  for j in 0.0001 0.001 0.01 0.1 0.5 1
#  for j in 0.01
  do
      for i in $(seq 1 10)
      do
        swipl -s $1/generate_BK.pl -g "generate_background($j,$k),halt" -q
        case $method in
  #        swipl -s $1/route.pl -g halt -q
  # B-Prolog
          bpl)
          cd $1
          ~/workspace/BProlog/bp -s 40000000 -g "consult(b_prolog),compute" | sed -n "4p"
          cd ../../../
          ;;
  # XSB-Prolog
          xsbpl)
          cd $1
          ~/workspace/XSB/bin/xsb -e "consult(xsb_prolog),compute." --quietload | sed 's/^.* | ?- //'
          cd ../../../
          ;;
  # Clingo
          clg)
          cp $1/background.pl $1/background.lp
          clingo -q --time-limit=5000 $1/background.lp $1/clingo.lp | sed -n "9p" | sed 's/^.*: //' | sed 's/.$//'
          ;;
  # Souffle
          souffle)
          swipl -s $1/generate_BK.pl -g "conversion_background_to_dl,halt" -q
          cd $1
          souffle -c -F . -D . souffle.dl -p souffle.log
          souffleprof souffle.log -j=${j}pe_${k}nodes.html > /dev/null
          cat ${j}pe_${k}nodes.html | grep "data={" | sed 's/.*\[//' | sed 's/,.*//'
          rm -f *.html *.facts *.csv *.log
          cd ../../../
          ;;
        esac
      done>./${method}_${j}pe_${k}nodes.txt
  done
done

#for k in 1000 2000 3000 4000 5000
#do
#  for j in 0.001
#  do
#      for i in $(seq 1 10)
#      do
#        swipl -s $1/generate_BK.pl -g "generate_background($j,$k),halt" -q
##        swipl -s $1/route.pl -g halt -q
#  #      B-Prolog
##        cd $1
##        bash b_prolog.sh | sed -n "4p"
##        cd ../../../
####   XSB-Prolog
#        cd $1
#        bash xsb_prolog.sh | sed 's/^.*| ?- //'
#        cd ../../../
#  #   Clingo
##        cp $1/background.pl $1/background.lp
##        clingo -q --time-limit=5000 $1/background.lp $1/clingo.lp | sed -n "9p" | sed 's/^.*: //' | sed 's/.$//'
#      done>./xsbpl_${j}pe_${k}nodes_partial.txt
#  done
#done

############################## metabolic network ####################################
#for k in 1 10 100 1000
##for k in 1000
#do
#  for i in $(seq 1 100)
##  for i in $(seq 1 1)
#  do
#    swipl -s $1/generate_BK.pl -g "generate_background($k),halt" -q
##    swipl -s $1/metabolic_path.pl -g halt -q
##      B-Prolog
##      cd $1
##      bash b_prolog.sh | sed -n "4p"
##      cd ../../../
##   Clingo
##      sed "s/'/\"/g" $1/background.pl > $1/background.lp
##      clingo -q --time-limit=5000 $1/background.lp $1/clingo.lp | sed -n "9p" | sed 's/^.*: //' | sed 's/.$//'
##   XSB-Prolog
#      cd $1
#      bash xsb_prolog.sh | sed 's/^.*| ?- //'
#      cd ../../../
#  done>./xsbpl_${k}.txt
##  done
#done