import android.content.Context
import android.graphics.Bitmap
import com.google.firebase.ml.modeldownloader.CustomModel
import com.google.firebase.ml.modeldownloader.CustomModelDownloadConditions
import com.google.firebase.ml.modeldownloader.DownloadType
import com.google.firebase.ml.modeldownloader.FirebaseModelDownloader
import org.tensorflow.lite.Interpreter
import java.io.BufferedReader
import java.io.InputStreamReader
import java.nio.ByteBuffer
import java.nio.ByteOrder

class AnimalClassifier(private val context: Context) {

    private var interpreter: Interpreter? = null
    private var labels: List<String> = emptyList()

    // 1. Initialize: Download Model & Load Labels
    fun initialize() {
        // Load labels from assets
        labels = loadLabels("labels.txt")

        // Download model from Firebase
        val conditions = CustomModelDownloadConditions.Builder()
            .requireWifi()  // Optional: Download only on WiFi
            .build()

        FirebaseModelDownloader.getInstance()
            .getModel("animal_classifier", DownloadType.LOCAL_MODEL, conditions)
            .addOnSuccessListener { model: CustomModel? ->
                // Model downloaded successfully. Get the file handle.
                val modelFile = model?.file
                if (modelFile != null) {
                    interpreter = Interpreter(modelFile)
                    println("Model loaded successfully")
                }
            }
            .addOnFailureListener {
                println("Model download failed: ${it.message}")
            }
    }

    // 2. Helper to read labels.txt
    private fun loadLabels(fileName: String): List<String> {
        val labelList = ArrayList<String>()
        try {
            val reader = BufferedReader(InputStreamReader(context.assets.open(fileName)))
            var line: String? = reader.readLine()
            while (line != null) {
                // The file contains "0 Lion", "1 Tiger". We often just want the name.
                // This split logic assumes the format "Index Name" or just "Name"
                labelList.add(line) 
                line = reader.readLine()
            }
            reader.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return labelList
    }

    // 3. Run Inference
    fun classifyImage(bitmap: Bitmap): String {
        val interp = interpreter ?: return "Model not initialized"

        // Preprocess the image (Resize to 224x224 is standard for TeachableMachine/MobileNet)
        val resizedBitmap = Bitmap.createScaledBitmap(bitmap, 224, 224, true)
        val inputBuffer = convertBitmapToByteBuffer(resizedBitmap)

        // Output buffer: [1, 10] because you have 10 animals
        val outputBuffer = Array(1) { FloatArray(10) }

        // Run the model
        val inputs = arrayOf(inputBuffer)
        val outputs = HashMap<Int, Any>()
        outputs[0] = outputBuffer
        interp.runForMultipleInputsOutputs(inputs, outputs)

        // Find the index with the highest probability
        val probabilities = outputBuffer[0]
        val maxIndex = probabilities.indices.maxByOrNull { probabilities[it] } ?: -1

        if (maxIndex != -1 && maxIndex < labels.size) {
            val confidence = probabilities[maxIndex] * 100
            return "${labels[maxIndex]} (${String.format("%.1f", confidence)}%)"
        }

        return "Unknown"
    }

    // Standard helper to convert Bitmap to ByteBuffer (Standard RGB)
    private fun convertBitmapToByteBuffer(bitmap: Bitmap): ByteBuffer {
        val byteBuffer = ByteBuffer.allocateDirect(4 * 224 * 224 * 3)
        byteBuffer.order(ByteOrder.nativeOrder())
        val intValues = IntArray(224 * 224)
        bitmap.getPixels(intValues, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight())
        
        var pixel = 0
        for (i in 0 until 224) {
            for (j in 0 until 224) {
                val value = intValues[pixel++]
                // Normalize pixel values to [-1, 1]
                // (value - 127.5) / 127.5
                byteBuffer.putFloat(((value shr 16 and 0xFF) - 127.5f) / 127.5f)
                byteBuffer.putFloat(((value shr 8 and 0xFF) - 127.5f) / 127.5f)
                byteBuffer.putFloat(((value and 0xFF) - 127.5f) / 127.5f)
            }
        }
        return byteBuffer
    }
}
