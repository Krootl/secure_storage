package com.krootl.secure_storage

import androidx.annotation.NonNull

import com.google.android.gms.auth.blockstore.Blockstore
import com.google.android.gms.auth.blockstore.DeleteBytesRequest
import com.google.android.gms.auth.blockstore.RetrieveBytesRequest

import com.google.android.gms.auth.blockstore.StoreBytesData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SecureStoragePlugin */
class SecureStoragePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugin.krootl.com/blockstore/method")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method.equals("put")) {
            val key = call.argument<String>("key")
            val value = call.argument<String>("value")
            if (key != null && value != null) putBlockStoreData(key, value)

            result.success(null)
        } else if (call.method.equals("get")) {
            val key = call.argument<String>("key")
            getBlockStoreData(key!!, result)
        } else if (call.method.equals("delete")) {
            deleteBlockStoreData()
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    private fun putBlockStoreData(key: String, value: String) {
        val request = StoreBytesData.Builder()
                .setShouldBackupToCloud(true)
                .setBytes(value.toByteArray())
                .setKey(key)
                .build()

        blockstoreClient.storeBytes(request)
    }

    private fun getBlockStoreData(key: String, channelResult: MethodChannel.Result) {
        val response = RetrieveBytesRequest.Builder().setRetrieveAll(true).build()

        blockstoreClient.retrieveBytes(response).addOnSuccessListener { result ->
            result.blockstoreDataMap.forEach { (k, value) ->
                if (key == k) {
                    channelResult.success(String(value.bytes))
                    return@addOnSuccessListener
                }
            }
            channelResult.success(null)
        }.addOnFailureListener {
            channelResult.error("BLOCKSTORE", "Failed to retrieve data", null)
        }
    }

    private fun deleteBlockStoreData() {
        val deleteBytesRequest = DeleteBytesRequest.Builder().setDeleteAll(true).build()
        blockstoreClient.deleteBytes(deleteBytesRequest)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
