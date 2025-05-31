#! /bin/bash

# This script is used to run active and random selection of experiments for learning the isoenzyme function associated with tyrB in iML1515 model.
python src/framework/abduction.py ase experiments/iML1515/abduction/isoenz_learning --use_output experiments/iML1515/abduction/isoenz_learning --steps [1,2,4,5,8,10,15,16,20,25,30,32,64,128,256]
python src/framework/abduction.py rand experiments/iML1515/abduction/isoenz_learning --use_output experiments/iML1515/abduction/isoenz_learning --steps [1,2,4,5,8,10,15,16,20,25,30,32,64,128,256]