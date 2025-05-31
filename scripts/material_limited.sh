#! /bin/bash

# This script is used to run active and random selection of experiments for gene function learning in iML1515 model.

# Calling active selection of experiments
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b0720 --single_gene b0720 --costCap [1,10,50,100,500,1000,5000,10000]
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b1136 --single_gene b1136 --costCap [1,10,50,100,500,1000,5000,10000]
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b3729 --single_gene b3729 --costCap [1,10,50,100,500,1000,5000,10000]

# Called random selection of experiments
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b0720 --single_gene b0720 --costCap [1,10,50,100,500,1000,5000,10000]
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b1136 --single_gene b1136 --costCap [1,10,50,100,500,1000,5000,10000]
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b3729 --single_gene b3729 --costCap [1,10,50,100,500,1000,5000,10000]