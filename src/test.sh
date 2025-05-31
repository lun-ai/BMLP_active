#! /bin/bash

# Prolog Unit tests for
#   1) correctness of boolean matrix operations for simulation (giving binary decision classifications)
#   2) abduction and active learning
#
# mstate* tmstate* are intermediate output

###############################################################
#
# tests of boolean matrix (logical matrix) and abduction
# on metabolic network

rm -f mstate* tmstate*
swipl -s src/framework/deduction/test.pl -t "run_tests" > /dev/null
rm -f mstate* tmstate*

rm -f mstate* tmstate*
rm -f experiments/iML1515/abduction/temp/*
swipl -s src/framework/abduction/test.pl -t "run_tests" > /dev/null
rm -f mstate* tmstate*