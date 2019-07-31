package top.milesyang.clreader;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.jsoup.Jsoup;

public class Util {
	public static String urlEncode(String s, String charset) {
		try {
			return URLEncoder.encode(s, charset);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return "";
		}
	}

	public static void print(String s) {
		System.out.println(s);
	}

	public static String replaceTag(String s) {
		return s.replaceAll("<br>", "\n")
				.replaceAll("&nbsp;", " ")
				.replaceAll("<[^>]+>", "");
	}
}
