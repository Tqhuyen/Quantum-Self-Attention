#### General information

**Name**
Quang-Huyen Tran

**Affiliation** (optional)
National Chung Cheng University, Taiwan

--------------------------------------------------------------------------------

#### Demo information

**Title**
Efficient Circuit Classifier Design for Enhancing Quantum Self-Attention in Vision Transformers

**Abstract**
Official implementation of our paper on enhancing quantum self-attention with trainable circuit classifiers. We replace the direct measurement of the quantum self-attention register with a strongly entangling-layers circuit classifier and reproduce all experiments on the MC (QNLP) and Downscaled MNIST benchmarks, including an optimizer study (Nesterov momentum converges fastest and most stably) and a study of classifier depth (10-16 layers works best; deeper circuits degrade). Under identical settings, the circuit classifier reaches at least +10% training accuracy over the QSAN, QKSAN (Am+He / Am+QAOA) and QSANN baselines.

**Relevant links**
- Code repository: https://github.com/Tqhuyen/Quantum-Self-Attention
- Paper: https://doi.org/10.1109/gcwkshps68340.2025.11591004 (IEEE Globecom Workshops, GC Wkshps 2025)
- Related PennyLane demo based on this work: https://github.com/PennyLaneAI/demos/pull/1861
