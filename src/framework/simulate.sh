#! /bin/bash

NUM_THREADS=1
NUM_BATCH=1
BATCH_SIZE=100
ALL="part"
APP="src/framework/deduction"

RUN_ID=$(date +"%m_%d_%Y_%H:%M:%S")

EX_SOURCE=""

# different options to run the simulator
while getopts 'n:s:o:' flag; do
  case "${flag}" in
  n) BATCH_SIZE=$OPTARG ;;  # simulations can run in batches
  s) EX_SOURCE=$OPTARG ;;   # source path of example pool
  o) RUN_ID=$OPTARG ;;      # optional ID to distinguish runs, useful when there are multiple processes running
  *) break ;;
  esac
done

OUT_PATH=results/$RUN_ID
# output path of sampled examples and classifications
EX_PATH=$OUT_PATH/examples.pl
RES_PATH=$OUT_PATH/results.pl

mkdir -p results
rm -rf $OUT_PATH/*
mkdir -p $OUT_PATH

# sample examples and create a new folder for experiment results
swipl -s src/framework/deduction/sample.pl -q -t "sample('$EX_SOURCE','$EX_PATH',all)"

fp=0
while read line; do
  if [ -n "$line" -a "$line" != " " ]; then
    bid=$((fp / BATCH_SIZE + 1))
    echo $line >>$OUT_PATH/ex_${bid}
    fp=$((fp + 1))
    NUM_BATCH=$bid
  fi
done <$EX_PATH


init_txt="%%%% Source: $EX_SOURCE, Batch: $NUM_BATCH, Example(s): $fp, TMN-Thread(s): $NUM_THREADS, ID: $RUN_ID %%%%"
echo $init_txt
echo $init_txt >$OUT_PATH/simulate.log

trap '' HUP INT

# run examples in batches
function parallel_simluate() {

  examples=$OUT_PATH/ex_$1
  results=$OUT_PATH/res_$1
  log=$OUT_PATH/log_$1

  if [ $APP == "progol" ]; then
    echo "TBC"

  else
    rm -f $OUT_PATH/mstate* $OUT_PATH/tmstate*
    swipl -q -s $APP/run.pl -t "simulations('$OUT_PATH/','$examples','$OUT_PATH/log','$results')." >>$OUT_PATH/batch_$1.log
    rm -f $OUT_PATH/mstate* $OUT_PATH/tmstate*
  fi

  complete_time=$(date +"%m_%d_%Y_%H:%M:%S")
  cat $OUT_PATH/res_$1 >>$RES_PATH
  echo -e "\n%%%% Batch NO. $1 completed at $complete_time %%%%\n" >>$OUT_PATH/simulate.log
  rm -f $OUT_PATH/ex_$1 $OUT_PATH/res_$1 $OUT_PATH/log_*
}

for ((bid = 1; bid <= $NUM_BATCH; bid++)); do
  start_time=$(date +"%m_%d_%Y_%H:%M:%S")
  echo -e "\n%%%% Batch NO. $bid initiated at $start_time %%%%\n" >>$OUT_PATH/simulate.log
  parallel_simluate $bid
done

echo "%%%% All classifications completed" >>$OUT_PATH/simulate.log
