package top.milesyang.clreader;
import javax.script.Invocable;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.jsoup.Jsoup;
import java.util.HashMap;


public class BookSrcRunner {
    private static final String successKey = "success";
    private static final String dataKey = "data";

    private ScriptEngine engine = new ScriptEngineManager().getEngineByName("javascript");
    private Invocable invocable;

    private String result(Boolean success, JSONObject data) {
        HashMap res = new HashMap();
        res.put(successKey, success);
        if (data != null) {
            res.put(dataKey, data);
        }
        Jsoup jsoup;
        return JSON.toJSONString(res);
    }

    private String invoke(String name, String arg) {
        try {
            Object object = invocable.invokeFunction(name, arg);
            JSONObject jsonObject = JSON.parseObject(object.toString());
            if (jsonObject.containsKey(successKey) && jsonObject.containsKey(dataKey)) {
                if (jsonObject.getBoolean(successKey)) {
                    return result(true, jsonObject.getJSONObject(dataKey));
                } else
                    return result(false, null);

            } else {
                return result(false, null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return result(false, null);
        }
    }


    public String eval(String src) {
        try {
            engine.eval(src);
            invocable = (Invocable) engine;
            return "";
        } catch (ScriptException e) {
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
}
