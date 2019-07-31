package top.milesyang.clreader;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

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
						if (methodCall.method.equals("search") ||
								methodCall.method.equals("getChapters") ||
								methodCall.method.equals("getContent")) {
							final Handler handler = new Handler(Looper.getMainLooper()) {
								@Override
								public void handleMessage(Message msg) {
									super.handleMessage(msg);
									if (msg.what == 1) {
										result.success((String) msg.obj);
									}
								}
							};
							new Thread(new Runnable() {
								@Override
								public void run() {
									BookSrcRunner runner = new BookSrcRunner();
									runner.eval((String) methodCall.argument("js"));
									Message msg = handler.obtainMessage(1,
											(Object) runner.invoke(methodCall.method, (String) methodCall.argument("str")));
									handler.sendMessage(msg);
								}
							}).start();
						} else {
							result.notImplemented();
						}
					}
				}
		);
	}
}
