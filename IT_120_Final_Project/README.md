# Wild Animals Scanner

A powerful Flutter application for identifying wild animals using on-device machine learning.

## Features

### 🔍 AI-Powered Scanning
-   **Real-time Classification**: Identify animals instantly using a TensorFlow Lite model.
-   **High Accuracy**: Optimized image processing with [-1, 1] normalization.
-   **Smart Confidence**: Filters out low-confidence results (<70%) to ensure accuracy.

### 📊 Analytics & Reports
-   **Interactive Statistics**: Visualize your scan history with a beautiful Pie Chart.
-   **PDF Reports**: Generate and export professional PDF reports of your scan history.
-   **Scan History**: Keep track of all your past identifications with timestamps and confidence scores.

### 🎨 Modern UI/UX
-   **Dark Mode**: Sleek, battery-saving dark theme with teal accents.
-   **Glassmorphism**: Premium visual effects for cards and overlays.
-   **Responsive Design**: Works seamlessly across different screen sizes.

## Tech Stack

-   **Framework**: Flutter
-   **ML Engine**: TensorFlow Lite (`tflite_flutter`)
-   **Charts**: `fl_chart`
-   **Reports**: `pdf`, `printing`
-   **Backend**: Firebase Core (for future extensibility)

## Getting Started

1.  **Clone the repository**
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## Assets

Ensure the following files are in your `assets/` directory:
-   `model_unquant.tflite`
-   `labels.txt`
