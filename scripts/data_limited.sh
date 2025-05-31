#! /bin/bash

# This script is used to run active and random selection of experiments for gene function learning in iML1515 model.

# Calling active selection of experiments
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b0720 --single_gene b0720 --steps [0,1,2,3,4,5,10,15,20,25,30]
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b1136 --single_gene b1136 --steps [0,1,2,3,4,5,10,15,20,25,30]
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b3729 --single_gene b3729 --steps [0,1,2,3,4,5,10,15,20,25,30]

# Called random selection of experiments
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b0720 --single_gene b0720 --steps [0,1,2,3,4,5,10,15,20,25,30]
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b1136 --single_gene b1136 --steps [0,1,2,3,4,5,10,15,20,25,30]
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b3729 --single_gene b3729 --steps [0,1,2,3,4,5,10,15,20,25,30]