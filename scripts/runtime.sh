#! /bin/bash
# This script is used to time BMLP and SWI Prolog on sampled experiments from the iML1515 dataset.
swipl -s experiments/iML1515/runtime/bmlp/eval.pl -t runtime_multi
swipl -s experiments/iML1515/runtime/bmlp/eval.pl -t runtime_multi_thread
swipl -s experiments/iML1515/runtime/swi/eval.pl -t runtime_multi
swipl -s experiments/iML1515/runtime/swi/eval.pl -t runtime_multi_thread