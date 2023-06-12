package stt_csr;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.ai.MyNaverInform;
import com.example.ai.NaverService;

@Controller
public class STTController {
	@Autowired
	@Qualifier("sttservice")
	NaverService service;
	
	// ai_images 파일리스트에서 음성파일만 걸러서 목록에 나오도록
	@RequestMapping("/sttinput")
	public ModelAndView sttinput() {
		File f =new File(MyNaverInform.path); 
		String[] filelist = f.list();
		
		String file_ext[] = {"mp3", "m4a", "wav"};
		//file_ext배열에 존재하는 확장자만 모델에 포함
		
		ArrayList<String> newfilelist = new ArrayList();
		for(String onefile : filelist) {
			//bangtan.1.2.jpg 파일 이름이 이런식이라면 마지막 점을 찾아야함. 마지막 점이 있는 위치 : lastIndexOf(".") 
			String myext = onefile.substring(onefile.lastIndexOf(".")+1); //마지막점의 위치+1에서부터 끝까지 출력 
			for( String imgext : file_ext) {
				if(myext.equals(imgext)) { //위에서 뽑아낸 확장자가 file_ext배열에 있는 애랑 같은지 비교
					newfilelist.add(onefile); //같으면 newfilelist에 추가
					break; //같은거 찾았으면 다른 확장자들과 비교할 필요 없으니까 반복문 멈추기.
				}
			}
		}

		ModelAndView mv= new ModelAndView();
		mv.addObject("filelist", newfilelist);
		mv.setViewName("sttinput");
		return mv;
	}
	
	@RequestMapping("/sttresult")
	public ModelAndView sttresult(String image, String lang) throws IOException{
		//서비스클래스 요청 - https://naveropenapi.apigw.ntruss.com/vision/v1/celebrity -json
		String sttresult = null;
		if(lang == null) {
			sttresult = service.test(image); //기본언어 kor
		}
		else {
			sttresult = ((STTServiceImpl)service).test(image, lang); 
		}
		ModelAndView mv = new ModelAndView();
		mv.addObject("sttresult", sttresult); 
		mv.setViewName("sttresult");
		
		//추가 - txt로 변환한 파일을 txt파일 형태로 MyNaverInform.path경로에 저장하기.
		//파일명 mp3파일이름_20230609112022.txt(현재날짜 년월일시분초)
		Date now = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String now_string = sdf.format(now);
		String filename = image.substring(0, image.lastIndexOf(".")) + "_" + now_string + ".txt";
		
		//FileWriter 저장
		FileWriter fw = new FileWriter(MyNaverInform.path + filename, false);
		JSONObject jsontext = new JSONObject(sttresult);
		String text = (String)jsontext.getString("text");
		fw.write(text);
		fw.close();
				
		return mv;
	}

	

}//class

