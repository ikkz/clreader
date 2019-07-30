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
						if (methodCall.method.equals("search")) {
							BookSrcRunner runner = new BookSrcRunner();
							runner.eval((String) methodCall.argument("js"));
							result.success(runner.search((String) methodCall.argument("str")));
						} else if (methodCall.method.equals("getChapters")) {
							BookSrcRunner runner = new BookSrcRunner();
							runner.eval((String) methodCall.argument("js"));
							result.success(runner.getChapters((String) methodCall.argument("str")));
						} else if (methodCall.method.equals("getContent")) {
							BookSrcRunner runner = new BookSrcRunner();
							runner.eval((String) methodCall.argument("js"));
							result.success(runner.getContent((String) methodCall.argument("str")));
						} else {
							result.notImplemented();
						}
					}
				}
		);
	}
}
