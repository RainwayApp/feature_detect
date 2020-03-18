package com.rainway.feature_detect

import android.app.Activity
import android.app.UiModeManager
import android.content.Context
import android.content.Context.UI_MODE_SERVICE
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FeatureDetectPlugin */
public class FeatureDetectPlugin(): FlutterPlugin, MethodCallHandler, ActivityAware {
  var activity: Activity? = null

  constructor(activity: Activity): this() {
    this.activity = activity;
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "com.rainway/feature_detect")
    //channel.setMethodCallHandler(FeatureDetectPlugin());
    channel.setMethodCallHandler { call, result -> onMethodCall(call, result) }
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {

      val channel = MethodChannel(registrar.messenger(), "com.rainway/feature_detect")
      val plugin = FeatureDetectPlugin()
      channel.setMethodCallHandler(FeatureDetectPlugin(registrar.activity()))
      //channel.setMethodCallHandler({call, result -> plugin.onMethodCall(call, result)})
      //channel.setMethodCallHandler { call, result -> onMethodCall(call, result) }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "hasSystemFeature") {
      val feature = call.argument<String>("feature")
      val version = call.argument<Int?>("version")
      var hasFeature: Boolean?
      hasFeature = activity?.packageManager?.hasSystemFeature(feature) ?: false
      /*
      min api level needs to be increased for this, consider it
      if (version == null) {
        hasFeature = activity?.packageManager?.hasSystemFeature(feature)
      }
      else {
        hasFeature = activity?.packageManager?.hasSystemFeature(feature, version)
      }
      */
      result.success(hasFeature)
    } else if (call.method == "getSystemAvailableFeatures") {
      val features = activity?.packageManager?.systemAvailableFeatures?.map { it.name }
      result.success(features)
    } else if (call.method == "getCurrentUiModeType") {
      if (activity == null) {
        result.success(0) //undefined mode
        return
      }
      val uiModeManager = activity!!.getSystemService(UI_MODE_SERVICE) as UiModeManager
      val uiMode = uiModeManager.currentModeType
      result.success(uiMode)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
