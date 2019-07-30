package Util;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class Util {
    public static String urlEncode(String s, String charset) {
        try {
            return URLEncoder.encode(s, charset);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return "";
        }
    }
}
