package top.milesyang.clreader;

import android.os.Bundle;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		GeneratedPluginRegistrant.registerWith(this);

		new MethodChannel(getFlutterView(), "clreader.miles_yang.top").setMethodCallHandler(
				new MethodChannel.MethodCallHandler() {
					@Override
					public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
						try {
							if (methodCall.method.equals("gbk_urlencode")) {
								result.success(java.net.URLEncoder.encode((String) methodCall.arguments, "GBK"));
							} else {
								result.notImplemented();
							}
						} catch (UnsupportedEncodingException e) {
							result.error(e.getMessage(), null, null);
						}
					}
				}
		);
	}
}
