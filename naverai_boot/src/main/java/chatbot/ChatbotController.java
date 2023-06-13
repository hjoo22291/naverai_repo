package chatbot;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.example.ai.MyNaverInform;

@Controller
public class ChatbotController {
   @Autowired
   @Qualifier("chatbotservice")
   ChatbotServiceImpl service;
   
   @Autowired
   @Qualifier("chatbotttsservice")
   ChatbotTTSServiceImpl ttsservice;
   
   @Autowired
   @Qualifier("chatbotsttservice")
   ChatbotSTTServiceImpl sttservice;
   
   @Autowired
   @Qualifier("pizzaservice")
   PizzaServiceImpl pizzaservice;
   
   
   @RequestMapping("/chatbotrequest")
   public String chatbotrequest() {
      return "chatbotrequest";
   }
   
   @RequestMapping("/chatbotresponse")
   public ModelAndView chatbotresponse(String request, String event) {
      String response = "";
      if(event.equals("웰컴메세지")) {
         response = service.test(request,"open");
      }else {
         response = service.test(request, "send");
      }
      ModelAndView mv = new ModelAndView();
      mv.addObject("response", response);
      mv.setViewName("chatbotresponse");
      return mv;
   }
   
   
   //기본답변만 분석 - ajax방법 -----------------------------------------------------------------------
   @RequestMapping("/chatbotajaxstart")
   public String chatbotajaxstart() {
      return "chatbotajaxstart";
   }
   
   @RequestMapping("/chatbotajaxprocess")
   public @ResponseBody String chatbotajaxprocess(String request, String event) {
	   String response = "";
	   if(event.equals("웰컴메세지")) {
		   response = service.test(request,"open");
	   }else {
		   response = service.test(request, "send");
	   }
	   return response; //이미 json형태
   }
   
   //기본+이미지+멀티링크 답변 모두 분석---------------------------------------------------------
   @RequestMapping("/chatbotajax")
   public String chatbotajax() {
      return "chatbotajax";
   }
   
   @RequestMapping("/chatbottts")
   @ResponseBody
   public String chatbottts(String text) { //챗봇답변
	   String mp3 = ttsservice.test(text); //답변 텍스트를 --  해당경로 저장 -- mp3파일이름 리턴
	   return "{\"mp3\" : \"" + mp3 + "\"}";
   }
   
   //음성질문에 답하는 챗봇 만들기 ------------------------------------------------------------------
   //음성 질문 서버 업로드
   @PostMapping("/mp3upload")
   @ResponseBody
   public String mp3uplaod(MultipartFile file1) throws IOException{
	   String uploadFile = file1.getOriginalFilename();//a.mp3이름 가져오기
	   String uploadPath = MyNaverInform.path;
	   File saveFile = new File(uploadPath + uploadFile);
	   file1.transferTo(saveFile);
	   return "{\"result\" : \"잘받았습니다.\"}";
   }
   
   //업로드한 음성질문 mp3파일을 텍스트 변환
   @RequestMapping("/chatbotstt")
   @ResponseBody
   public String chatbotstt(String mp3file) {
	   String text = sttservice.test(mp3file);
	   return text;
   }
   
   //피자주문내역 db에 넣기
   @RequestMapping("/pizzaorder")
   @ResponseBody
   public int pizzaorder(PizzaDTO dto) {
	   int result = pizzaservice.insertPizza(dto);
	   return result;
   }
   
   
}//class


