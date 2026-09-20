Enhancing quantum self-attention with strongly entangling circuit classifiers
=============================================================================

Build and train a quantum self-attention-inspired binary classifier with PennyLane and PyTorch,
following the circuit-classifier approach in [#Tran]_. Learn how its registers and readout work,
then adapt its data, depth, and training setup using the practical recipes at the end.

Quantum self-attention explores quantum-circuit alternatives to the classical self-attention
mechanism at the heart of modern deep-learning models. Several architectures were proposed recently,
including the quantum self-attention network (QSAN) [#QSAN]_, the quantum kernel self-attention
network (QKSAN) [#QKSAN]_ and the quantum self-attention neural network (QSANN) [#QSANN]_. Here we
explore a trainable circuit readout for classification rather than a fixed measurement alone.

1. **Build** each building block of the quantum self-attention network (amplitude encoding,
   query/key/value unitaries, the barbell swap operation, and the quantum-logic-similarity module)
   with PennyLane;
2. **Load** a small, PennyLane-native benchmark (downscaled MNIST [#Bowles]_) so the whole demo is
   self-contained;
3. **Train** the quantum layer with Nesterov momentum and inspect its training and test accuracy.

This is a small illustrative experiment, not a reproduction of the paper's benchmark comparisons.
CPU simulation does not establish a computational advantage over classical attention.

Prerequisites and scope
-----------------------

You should be comfortable with qubit gates, expectation values, binary classification, and basic
PyTorch optimization. For a gentler introduction to the learning loop, start with
:doc:`demos/tutorial_variational_classifier`.

This tutorial operates on one classical feature vector at a time. It is not a complete vision
transformer: it does not construct image patches, a token-to-token attention matrix, or a softmax
attention layer. Both the feature-extraction circuit and the classifier are trained jointly;
"feature extractor" does not mean that its parameters are frozen.

Running the Python script requires PennyLane, PennyLane-Lightning, PyTorch, Matplotlib, and the
PennyLane dataset dependencies (``h5py``, ``fsspec``, and ``aiohttp``). The first data load requires
network access. The repository's demo builder installs core dependencies and the additional
dependency in ``requirements.in``. Training a state-vector simulation can be expensive; see
the reduced-budget recipe below before running the full experiment.

How to adapt the experiment
---------------------------

The following recipes describe changes to the sections above, rather than launching additional
training runs. Restart from initialization after each independent experiment so that trained
parameters and optimizer momentum are not silently carried over.

Run a small smoke test
~~~~~~~~~~~~~~~~~~~~~~

Before a full run, change ``N_TRAIN, N_TEST = 50, 30`` to ``N_TRAIN, N_TEST = 2, 2`` and
``EPOCHS = 150`` to ``EPOCHS = 2``. Keep the register sizes and classifier depth unchanged to
exercise the actual architecture. This checks execution, not classification performance.
Restore the original budgets for the reported experiment. The full loop makes 130 sample-level
forward evaluations per epoch, in addition to the work required for derivatives.

To check gradients, insert the following immediately after ``loss.backward()``::

    for parameter in (weights, parameters):
        assert parameter.grad is not None
        assert torch.isfinite(parameter.grad).all()
        print(parameter.grad.norm().item())

A finite gradient is a numerical sanity check, not evidence that optimization will succeed.

Use your own binary dataset
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Replace the dataset-loading block with tensors from your own train/test split.

Compare results responsibly
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the same data splits and preprocessing for each method, tune only on validation data,
and repeat training with multiple seeds. Compare against a fixed circuit readout and a simple
classical classifier before claiming an improvement. Report held-out performance, variability,
parameter counts, and measured runtime; this tutorial alone does not establish quantum advantage.

Conclusion
----------

We have implemented a circuit inspired by quantum self-attention followed by a strongly
entangling classifier, and trained it using classical optimization. The printed metrics describe
this small MNIST experiment only. Reproducing the comparisons in [#Tran]_ requires matched data,
baselines, optimizer settings and repeated runs. In particular, this implementation does not feed
the QLS result register back through the slicing module.

To explore further, you can:

- increase the number of strongly entangling layers and study the interplay between entanglement
  depth and generalisation using a separate validation set;
- map the expectation value to class probabilities before trying a cross-entropy loss;
- apply the same architecture to other PennyLane-native datasets.

References
----------

.. [#Tran]
    Quang-Huyen Tran, Yu-Han Lin, Hanh T. M. Tran, Duy-Tuan Dao and Van-Linh Nguyen. Efficient
    Circuit Classifier Design for Enhancing Quantum Self-Attention in Vision Transformers. *IEEE
    GlobeCom Workshops (GC Wkshps)* (2025). DOI: https://doi.org/10.1109/gcwkshps68340.2025.11591004.

.. [#QSAN]
    Jinye Shi, Run-Xia Zhao, Wei Wang, Shangbin Zhang and Xi Li. QSAN: A Near-Term Achievable
    Quantum Self-Attention Network. *IEEE Trans. Neural Netw. Learn. Syst.* (2025). DOI:
    https://doi.org/10.1109/tnnls.2024.3504828.

.. [#QKSAN]
    Run-Xia Zhao, Jinye Shi and Xi Li. QKSAN: A Quantum Kernel Self-Attention Network. *IEEE Trans. Pattern
    Anal. Mach. Intell.* 46 (2024). DOI: https://doi.org/10.1109/tpami.2024.3434974.

.. [#QSANN]
    Guangxi Li, Xuanqiang Zhao and Xin Wang. Quantum Self-Attention Neural Networks for Text
    Classification. *Science China Informetics* 67 (2024). DOI: https://doi.org/10.1007/s11432-023-3879-7.

.. [#Schuld]
    Maria Schuld, Alex Bocharov, Krysta Svore and Nathan Wiebe. Circuit-Centric Quantum
    Classifiers. *Physical Review A* 101, 032308 (2020). DOI:
    https://doi.org/10.1103/PhysRevA.101.032308.

.. [#Bowles]
    Joseph Bowles, Shahnawaz Ahmed and Maria Schuld. PennyLane Datasets for "Better than
    classical?" The subtle art of benchmarking quantum machine learning models" (2024).
    https://pennylane.ai/datasets/downscaled-mnist.
