package chatbot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ChatbotController {
   @Autowired
   @Qualifier("chatbotservice")
   ChatbotServiceImpl service;
   
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
   
   //기본+이미지+멀티링크 답변 모두 분석
   @RequestMapping("/chatbotajax")
   public String chatbotajax() {
      return "chatbotajax";
   }
   
}