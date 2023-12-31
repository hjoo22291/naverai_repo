package tts_voice;

//네이버 음성합성 Open API 예제
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.example.ai.MyNaverInform;

public class APIExamTTS {

 public static void main(String[] args) {
     String clientId = MyNaverInform.voice_clientID;//애플리케이션 클라이언트 아이디값";
     String clientSecret = MyNaverInform.voice_secret;//애플리케이션 클라이언트 시크릿값";
     try {
         String text = URLEncoder.encode("지금은 네이버 플랫폼을 활용한 ai 서비스 진행중입니다.", "UTF-8"); // 2000자
         String apiURL = "https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts";
         URL url = new URL(apiURL);
         HttpURLConnection con = (HttpURLConnection)url.openConnection();
         con.setRequestMethod("POST");
         con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
         con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
         // post request
         String postParams = "speaker=nara&volume=0&speed=0&pitch=0&format=mp3&text=" + text;
         con.setDoOutput(true);
         DataOutputStream wr = new DataOutputStream(con.getOutputStream());
         wr.writeBytes(postParams);
         wr.flush();
         wr.close();
         int responseCode = con.getResponseCode();
         BufferedReader br;
         if(responseCode==200) { // 정상 호출
             InputStream is = con.getInputStream();
             int read = 0;
             byte[] bytes = new byte[1024];
             // 랜덤한 이름으로 mp3 파일 생성
             String tempname = "Voice_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
             //String tempname = "Voice_"+Long.valueOf(new Date().getTime()).toString(); //저장될 mp3파일 이름
             File f = new File(MyNaverInform.path + tempname + ".mp3");
             f.createNewFile();
             OutputStream outputStream = new FileOutputStream(f); //txt를 음성으로 변환한 결과를 이 파일에 기록해라.
             while ((read =is.read(bytes)) != -1) {
                 outputStream.write(bytes, 0, read);
             }
             is.close();
             System.out.println(tempname + ".mp3 파일은 해당 경로에서 확인하세요.");
         } else {  // 오류 발생
             br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
             String inputLine;
             StringBuffer response = new StringBuffer();
             while ((inputLine = br.readLine()) != null) {
                 response.append(inputLine);
             }
             br.close();
             System.out.println(response.toString());
         }
     } catch (Exception e) {
         System.out.println(e);
     }
 }
}