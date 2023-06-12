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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.ai.MyNaverInform;
import com.example.ai.NaverService;

import stt_csr.STTServiceImpl;

@Controller
public class MapController_ajax {
	@Autowired
	@Qualifier("mapservice")
	NaverService service;
	
	@Autowired
	@Qualifier("ttsservice")
	NaverService service_tts;
	
	@GetMapping("/myinput_ajax")
	public String myinput() {
		return "/mymapping/myinput_ajax";
	}
	
	@RequestMapping("/myoutput_ajax")
	@ResponseBody //sts4에선 pom.xml 라이브러리 추가할 필요 X. 자동추가됨.
	public String myoutput(String input) throws IOException {
		//입력받은 질문을 MapServiceImpl로 보내서 해당 질문에 대한 답변 받기.
		String text = service.test(input);

		FileWriter fw = new FileWriter(MyNaverInform.path + "response.txt"); //파일명 하나로 지정하면 계속 덮어씌워짐(여러개안생김)
		fw.write(text);
		fw.close();
		String ttsresult = service_tts.test("response.txt"); 
		
		return "{\"text\" : \""  +  text + "\" , \"ttsresult\":\"" + ttsresult + "\" }";
	}
	
	
}
