# Efficient Circuit Classifier Design for Enhancing Quantum Self-Attention in Vision Transformers

This repository contains the code for a fully quantum self-attention model that combines the
Quantum Self-Attention Network (QSAN) with a **strongly entangling-layers circuit classifier**, as
described in the accompanying paper
[Efficient Circuit Classifier Design for Enhancing Quantum Self-Attention in Vision Transformers](https://ieeexplore.ieee.org/document/11591004/authors#authors).

Quantum self-attention is a promising replacement for classical self-attention, which typically
requires massive GPU resources. However, early quantum self-attention architectures struggle with
classification tasks. This work addresses that limitation by treating QSAN as a *feature extractor*
and appending a **strong entangling layers classifier**, enabling the whole pipeline to run on
quantum hardware.

## Key Idea

- Use QSAN as a quantum feature extractor (compute the Query / Key / Value states and the
  Quantum Logic Similarity (QLS) score), removing the compression and slicing operations.
- Feed the measured features into a **strongly entangling layers** ansatz used as a quantum classifier.
- Systematically vary the number of strong entangling layers (1–18) to find the optimal
  entanglement depth.
- Evaluate 5 state-of-the-art optimizers to identify the best training strategy.

## Repository Structure

```
.
├── comparison_with_mc_datasets/      # Experiments on the MC (QNLP) dataset
│   ├── our_method_with_15_layers.ipynb   # Proposed model: QSAN + strong entangling layers
│   ├── qksan-amhe-nlp.ipynb              # Baseline: QKSAN (Am+He classifier)
│   ├── qksan-amqaoa-nlp.ipynb            # Baseline: QKSAN (Am+QAOA classifier)
│   └── QSANN.ipynb                       # Baseline: QSANN
├── comparison_with_mnist_datasets/   # Experiments on Downscaled MNIST
│   ├── qksan-amhe-mnist.ipynb
│   └── qksan-amqaoa-mnist.ipynb
└── different_optmizers/              # Optimizer comparison (MC dataset)
    ├── adam_optimizer.ipynb
    ├── adagrad_optimizer.ipynb
    ├── gradient_descent_optimizer.ipynb
    └── momentum_optimizer.ipynb
```

## Datasets

| Dataset | Description | Source |
| --- | --- | --- |
| **MC (QNLP)** | 130 four-word sentences labeled as IT or non-IT/cooking (70 train / 30 dev / 30 test) | [Kaggle: MC and RP dataset for quantum computing QNLP](https://www.kaggle.com/) |
| **Downscaled MNIST** | MNIST compressed with PCA, dimension `d = 16`; binary task distinguishing digits 3 and 5 (50 train / 30 test samples) | [PennyLane datasets](https://pennylane.ai/datasets/downscaled-mnist) |

## Key Results

- **Layer count (strong entangling layers):** best testing accuracy reaches **~56%** with
  10–16 layers; accuracy does not monotonically improve with depth (over/under-fitting effects).
- **Optimizers:** **Nesterov Momentum** converges fastest (10 epochs, ~120 s) and most stably;
  Adam converges slowly and is unstable during training.
- **SOTA comparison:** the proposed model achieves **100% / 56%** (train/test) on MC and
  **100% / 40%** on MNIST, outperforming QSAN, QKSAN (Am+He / Am+QAOA), and QSANN by 10–23%.

| Model | Qubits | Depth | Classification Method | Train / Test Acc. |
| --- | --- | --- | --- | --- |
| QSAN | 3n | 9 | Direct Measurement | 72% / 40% |
| QKSAN (Am+He) | 2n | 4 | QAOA-based Classifier | 76% / 42% |
| QKSAN (Am+QAOA) | 2n | 4 | QAOA-based Classifier | 76% / 50% |
| QSANN | 3n | 3 | Variational Classifier | 92% / 53% |
| QSANM | 3n | 4 | Direct Measurement | 78% / 50% |
| **Ours** | 3n | 9 | Strong Entangling Layer | **100% / 56%** |

## Requirements

The notebooks run on **CPU-only** (e.g., Kaggle) and require:

- [PennyLane](https://pennylane.ai) (quantum circuit simulation)
- TensorFlow (used in some baseline notebooks)
- Matplotlib
- Python 3.x

Install with:

```bash
pip install pennylane tensorflow matplotlib
```

Experiments were simulated on a 16-qubit quantum computer (16-dimensional input, amplitude encoding).

## Usage

1. Download the MC dataset from Kaggle and place the `mc_train_data.txt`, `mc_dev_data.txt`,
   and `mc_test_data.txt` files in the path expected by the notebook
   (`/kaggle/input/mc-and-rp-dataset-for-quantum-computing-qnlp/`), or adjust the path.
2. Open any notebook in Jupyter / Kaggle and run all cells.

## Authors

- Huyen Quang Tran — National Chung Cheng University, Taiwan
- Yu-Han Lin — National Chung Cheng University, Taiwan
- Hanh Thi Minh Tran — Danang University of Science and Technology, Vietnam
- Duy-Tuan Dao — Danang University of Science and Technology, Vietnam
- Van-Linh Nguyen — National Chung Cheng University, Taiwan

## Citation

If you use this code in your research, please cite the accompanying paper:

```bibtex
@article{tran2025efficient,
  title  = {Efficient Circuit Classifier Design for Enhancing Quantum Self-Attention in Vision Transformers},
  author = {Tran, Huyen Quang and Lin, Yu-Han and Tran, Hanh Thi Minh and Dao, Duy-Tuan and Nguyen, Van-Linh},
  year   = {2025}
}
```

## License

This project is for research purposes. Please contact the authors for further details.
