# Design of Pseudorandom Bit Generators Using Chaotic Systems

## Overview

This repository contains the MATLAB implementations developed as part of a thesis focused on the design and analysis of chaos-based pseudorandom bit generators (PRBGs). The project introduces several novel chaotic maps based on the Soboleva Modified Hyperbolic Tangent Function (SMHT) and investigates their suitability for cryptographic applications.

The repository includes scripts for the analysis of the proposed chaotic systems, randomness evaluation, and image encryption experiments.

## Repository Contents

### 2d and 3d phase diagrams  for:

* Chebysev Map
* Renyi Map

### Proposed Chaotic Maps

Implementation of the proposed Soboleva-based chaotic systems:

* Soboleva-Rem Map
* Soboleva-Tent Map
* Piecewise Soboleva Map

* ### Classic Chaotic Maps

* Logistic Map
* Sine Map
* Tent Map

### Dynamical Analysis

For each proposed map, the following analyses are provided:

* Bifurcation Diagrams
* Lyapunov Exponent Diagrams

### Image Encryption

MATLAB implementations of image encryption schemes based on the generated chaotic sequences, including:

* Pixel Shuffling (Permutation)
* XOR-Based Diffusion

### Image Encryption Evaluation

Scripts for evaluating encryption performance through:

* Histogram Analysis
* Pixel Correlation Analysis

### Randomness Testing

The generated bit sequences were evaluated using the NIST Statistical Test Suite (SP 800-22). The repository contains scripts used to generate pseudorandom sequences suitable for NIST testing.

## Software Requirements

* MATLAB R2020a or newer (recommended)
* Image Processing Toolbox (for image encryption experiments)

## Citation

If you use any part of this repository in your research, please cite the corresponding thesis and related publications.
