package top.milesyang.clreader;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import org.jsoup.Jsoup;

import java.util.HashMap;

import org.mozilla.javascript.Context;
import org.mozilla.javascript.Function;
import org.mozilla.javascript.Scriptable;
import org.mozilla.javascript.ScriptableObject;


public class BookSrcRunner {
	private static final String successKey = "success";
	private static final String dataKey = "data";

	private Context ctx;
	private Scriptable scope;

	private String result(Boolean success, JSONObject data) {
		HashMap res = new HashMap();
		res.put(successKey, success);
		if (data != null) {
			res.put(dataKey, data);
		}
		return JSON.toJSONString(res);
	}

	public String invoke(String name, String arg) {
		try {
			Object func = scope.get(name, scope);
			if (!(func instanceof Function)) {
				return result(false, null);
			} else {
				Object functionArgs[] = {arg};
				Function f = (Function) func;
				Object result = f.call(ctx, scope, scope, functionArgs);
				JSONObject jsonObject = JSON.parseObject(Context.toString(result));
				if (jsonObject.containsKey(successKey) && jsonObject.containsKey(dataKey)) {
					if (jsonObject.getBoolean(successKey)) {
						return result(true, jsonObject.getJSONObject(dataKey));
					} else
						return result(false, null);

				} else {
					return result(false, null);
				}
			}


		} catch (Exception e) {
			e.printStackTrace();
			return result(false, null);
		}
	}


	public String eval(String src) {
		try {
			ctx = Context.enter();
			ctx.setOptimizationLevel(-1);
			scope = ctx.initStandardObjects();
			ctx.evaluateString(scope, src, "<book_src>", 1, null);
			Object wrappedUtil = Context.javaToJS(new Util(), scope);
			ScriptableObject.putConstProperty(scope, "Util", wrappedUtil);
			return "";
		} catch (Exception e) {
			e.printStackTrace();
			return result(false, null);
		}
	}

	public String search(String name) {
		return invoke("search", name);
	}

	public String getChapters(String url) {
		return invoke("getChapters", url);
	}

	public String getContent(String url) {
		return invoke("getContent", url);
	}

	@Override
	protected void finalize() throws Throwable {
		try {
			if (ctx != null) {
				Context.exit();
			}
		} catch (IllegalStateException e) {
		}
		super.finalize();
	}
}
