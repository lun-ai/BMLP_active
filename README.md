# Boolean matrix logic programming for active learning of gene functions in genome-scale metabolic network models

This repository contains source code and data for the SWI-Prolog system $BMLP_{active}$, which actively selects data to learn gene function annotations from genome-scale metabolic network models. 

## Framework

$BMLP_{active}$ explores the functional genomic hypothesis space by guiding informative experimentation through interpretable logical representation. It is based on a general purpose logic programming language SWI-Prolog and accelerated logical inference accommodated by Boolean matrix computation (Boolean Matrix Logic Programming, BMLP). $BMLP_{active}$ takes the advantage of fast computation, logical reasoning and active learning to enable rapid optimisation of metabolic models.

![Framework_overview](figs/bmlp_active.png)

$BMLP_{active}$ encodes the genome-scale metabolic network model (GEM) iML1515 as Boolean matrices and predicts the auxotrophic mutant phenotypes. It actively consults a data source to request ground truth labels that minimise the expected experimental cost based on a user-provided cost function when pruning hypotheses. The underlying BMLP iteratively refutes gene function hypotheses inconsistent with labelled training examples.

## Dependency
- Python
  - matplotlib
  - numpy
  - seaborn
- SWI-Prolog >= 9.2

## Usage
### GEM phenotype predictions
Running BMLP-IE algorithm require pre-defined experiment candidates. An example of experiment candidates can be found at library/double_knockout/examples.pl.

```commandline
bash src/framework/simulate.sh -n <batch_size> -s <path_to_experiments>
```
`batch_size`: This denotes the size of a simulation batch (default is 100).

`path_to_experiments`: This argument is is the source path of experiment candidate definitions. 

Example command:
```commandline
bash src/framework/simulate.sh -n 500 -s library/double_knockout/examples.pl
```

### Active selection of experiment (ase)
ASE requires a dependency file that contains all relevant references to background knowledge, abducible and example generation methods. 

Then to invoke ase:
```
python src/framework/abduction.py ase <abducible_and_experiment_candidate_path> --use_output <classification_matrix_path> --single_gene <gene_id> --steps <step_list>
```

`abducible_and_experiment_candidate_path`: This argument specifies the path to a file that contains or generates the candidate abducibles and experiment candidates. Abducibles are potential hypotheses or explanations, and experiment candidates are potential experiments that can be performed to test these hypotheses. 

`classification_matrix_path`: This argument specifies the path to the classification matrix (a matrix of predicted labels). This matrix is used in the abduction process to evaluate hypotheses based on their consistency with observed data (see next section). 

`gene_id`: This argument specifies the identifier of the gene being investigated. The abduction process will focus on learning the function of this particular gene.

`step_list`: This argument specifies a list of steps or iterations for the abduction process. It controls the number of iterations or specific stages in the active learning loop.

An example is provided in experiments/iML1515/abduction/gene_function_learning:
```
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --use_output experiments/iML1515/abduction/output/gene_function_learning/abd_b0720 --single_gene b0720 --steps [0,1,2,3,4,5,10,15,20,25,30] --rep 10
```

### Classification table
This classification matrix needs to be computed before running ase due to long computation time.

To compute the classification matrix:
```
python src/framework/abduction.py ase <abducible_and_experiment_candidate_path> --single_gene <gene_id> --matrix
```

Example command (can take quite long):
```
python src/framework/abduction.py ase experiments/iML1515/abduction/gene_function_learning --single_gene b0720 --matrix
```

## Reproducibility
Scripts to reproduce results are in the scripts/ folder. Computed results will be placed in a separate folder. We provided a Jupyter notebook (src/result_analysis.ipynb) to process results. 

## Reference

```commandline
@misc{ai2024boolean,
      title={Boolean matrix logic programming for active learning of gene functions in genome-scale metabolic network models}, 
      author={Lun Ai and Stephen H. Muggleton and Shi-Shun Liang and Geoff S. Baldwin},
      year={2024},
      eprint={2405.06724},
      archivePrefix={arXiv},
      primaryClass={q-bio.MN}
}
```

## License [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Distributed under the MIT License. See LICENSE.txt for more information.

## Contact
[Lun Ai, PhD](https://lai1997.github.io/) (corresponding author)

Email: lun.ai.public@gmail.com
