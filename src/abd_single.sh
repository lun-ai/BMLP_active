#!/bin/bash
echo "Abduction single gene: $1"
rm -rf results/abd_$1
rm output_$1.log
nohup python3 framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --single_gene $1 --id $1 > output_$1.log &