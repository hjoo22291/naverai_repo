package mymapping;

import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.ai.MyNaverInform;
import com.example.ai.NaverService;

import stt_csr.STTServiceImpl;

@Controller
public class MapController {
	@Autowired
	@Qualifier("mapservice")
	NaverService service;
	
	@Autowired
	@Qualifier("ttsservice")
	NaverService service_tts;
	
	//url에 myinput입력했을때 myinput.jsp를 뷰로 전달
	@GetMapping("/myinput")
	public String myinput() {
		return "/mymapping/myinput";
	}
	
	//form으로 질문 입력받았을때 : form action="myoutput"
	@RequestMapping("/myoutput")
	public ModelAndView myoutput(String input) throws IOException {
		//입력받은 질문을 MapServiceImpl로 보내서 해당 질문에 대한 답변 받기.
		String text = service.test(input);

		//받은 답변을 txt파일 형태로 MyNaverInform.path경로에 저장하기.
		//txt파일 이름설정 (꼭해야하는건아님)
//		Date now = new Date();
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
//		String now_string = sdf.format(now);
//		String filename = "reply_"+ now_string + ".txt";
//		
//		//FileWriter를 이용해 text파일로 저장
//		FileWriter fw = new FileWriter(MyNaverInform.path + filename, false);
//		fw.write(text);
//		fw.close();
//		
//		//음성으로 내보내기(TTSServiceImpl에게 전달)
//		String ttsresult = service_tts.test(filename);
		
		//강사님 풀이 --------------------------------------------------------------------
		//답변 txt 생성
		FileWriter fw = new FileWriter(MyNaverInform.path + "response.txt"); //파일명 하나로 지정하면 계속 덮어씌워짐(여러개안생김)
		fw.write(text);
		fw.close();
		String ttsresult = service_tts.test("response.txt"); 
		//-----------------------------------------------------------------------------
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("text", text); //답변이 뭔지 보여주려고 전달
		mv.addObject("ttsresult", ttsresult); //답변을 들려주기위해 전달
		mv.setViewName("/mymapping/myoutput");
		return mv;
	}
	
	
}
