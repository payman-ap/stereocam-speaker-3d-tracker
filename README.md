# Multi-Camera 3D Speaker Tracking & Localization System

An advanced computer vision and spatial computing application designed for real-time 3D head pose estimation, orientation tracking, and spatial localization of multiple speakers in an indoor environment using dual-stereo camera setups. 

This project implements robust geometry techniques—including the **Perspective-n-Point (PnP)** problem for individual pose estimation and **Direct Linear Transformation (DLT)** for multi-camera triangulation—to achieve accurate 3D coordinate tracking ($X, Y, Z$) over a localized TCP network. Performance was validated and benchmarked against an industry-standard ground truth tracking device system.

---

## Key Features
* **Real-Time 3D Localization:** Computes exact $X, Y, Z$ spatial coordinates of target speakers using triangulation.
* **6-DOF Head Pose Estimation:** Extracts high-accuracy Pitch, Roll, and Yaw utilizing a refined 468-point facial mesh framework.
* **Distributed Network Architecture:** Built-in low-latency TCP client-server infrastructure enabling seamless real-time data streaming between independent processing nodes.
* **Comprehensive Calibration Pipeline:** Complete pipeline for resolving single-camera lens distortion parameters and multi-camera extrinsic matrices (Rotation $R$ and Translation $T$).
* **Data-Driven Validation:** Embedded tools to align, analyze, and benchmark captured metrics against precise physical position data.

---

## System Architecture & Mechanics

### 1. Head Pose Estimation (PnP Problem)
The system leverages a normalized 2D facial landmark mesh mapped against a rigid 3D reference head model. By solving the Perspective-n-Point problem via Iterative Levenberg-Marquardt optimization, it computes the rotation vector ($\mathbf{rvec}$) and translation vector ($\mathbf{tvec}$) relative to the camera lens:

$$\mathbf{x}_i = \mathbf{K} \left[ \mathbf{R} \mid \mathbf{t} \right] \mathbf{X}_i$$

### 2. Stereo Triangulation (DLT)
When target landmarks are registered simultaneously by both the primary and secondary camera nodes, the system applies a Direct Linear Transformation (DLT) algorithm. This reconstructs the rays in 3D space and minimizes geometric reprojection error to resolve the exact spatial point of the speaker.

---

## Directory Structure

```text
├── Camera_Calibration/         # Calibration scripts & matrix generation utilities
│   ├── calibration_matrix.yaml # Stored intrinsic & extrinsic camera coefficients
│   ├── cam_calibration.py      # Individual lens intrinsic calibration
│   └── stereocam_calibration.py# Multi-camera extrinsic stereo calibration
├── data/                       # Preprocessed metrics and verification datasets
│   └── sc4_data_personX_...    # Synchronized 3D telemetry tracking logs
├── Data_Analysis/              # Evaluation and kinematics analysis
│   ├── acceleration.m          # Numerical derivative calculation for dynamics 
│   └── quat_to_euler.m         # Rotational space transformation (Quaternion to Euler)
├── TCPConnection.py            # Low-level socket programming wrapping Server/Client nodes
├── utils.py                    # Algorithmic core (DLT solver, Triangulation, and PnP interfaces)
├── track.py                    # Main executable application entrypoint
└── requirements.txt            # Python ecosystem dependencies
```

--- 

## Getting Started

Prerequisites  
* Hardware: Two computing stations (or a single dual-bus system) equipped with two calibrated USB/Integrated cameras attached to the same network interface loop.
* Software: Python 3.8 or higher.
* (optional) Octave or MATLAB

1. Environment Setup

Clone the repository and install the verified dependencies:

```bash
pip install -r requirements.txt
```

⚠️ Apple Silicon Users (M1/M2/M3 MacBooks): Depending on your system architecture, you may need to install the mediapipe library explicitly through pre-compiled wheels if the core system framework architecture requests it.

2. Calibration Pipeline

Before running the tracker, you must compute the intrinsic lens parameters and extrinsic spatial orientation offsets:

Single-Camera Calibration: Place a standard chessboard pattern in view and run:

```bash
python Camera_Calibration/cam_calibration.py
```

Stereo-Camera Calibration: Capture synchronized frames across both devices using SimultCapture_StereoSetup.py, then extract the structural $R$ and $T$ matrices:

```bash
python Camera_Calibration/stereocam_calibration.py
```

Deploying the Runtime Nodes:  
The architecture operates as a synchronized distributed cluster. Configure the target host IP inside track.py to map to your server instance.

* Node A (Deploy as Tracker Server):

```bash
python track.py --server
```

* Node B (Deploy as Tracker Client):

```bash
python track.py
```


## Verification & Performance Analysis

The tracking accuracy of this application was evaluated alongside a reference ground truth tracker device system. The verification scripts inside /Data_Analysis extract structural signals, convert spatial orientation matrices, and calculate dynamic kinematic error distributions:

* Use `quat_to_euler.m` to map orientation variables into matching Euler Pitch/Roll/Yaw spaces.
* Run `acceleration.m` to check high-frequency noise tolerances across the camera streams versus the baseline device.









