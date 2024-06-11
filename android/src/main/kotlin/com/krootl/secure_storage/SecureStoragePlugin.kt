package com.krootl.secure_storage

import android.content.Context

import com.google.android.gms.auth.blockstore.Blockstore
import com.google.android.gms.auth.blockstore.BlockstoreClient
import com.google.android.gms.auth.blockstore.DeleteBytesRequest
import com.google.android.gms.auth.blockstore.RetrieveBytesRequest

import com.google.android.gms.auth.blockstore.StoreBytesData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

private const val METHOD_CHANNEL_BLOCK_STORE = "plugin.krootl.com/blockstore/method"
/** SecureStoragePlugin */
class SecureStoragePlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    private lateinit var blockstoreClient: BlockstoreClient

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        blockstoreClient = Blockstore.getClient(flutterPluginBinding.applicationContext)
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_BLOCK_STORE)
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
            val key = call.argument<String>("key")
            deleteBlockStoreData(key!!)
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

    private fun deleteBlockStoreData(key: String) {
        val mutableStringList: MutableList<String> = mutableListOf()
        mutableStringList.add(key)

        val deleteBytesRequest = DeleteBytesRequest.Builder().setKeys(mutableStringList).build()
        blockstoreClient.deleteBytes(deleteBytesRequest)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
