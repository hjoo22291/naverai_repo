package mymapping;


import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.springframework.stereotype.Service;

import com.example.ai.MyNaverInform;
import com.example.ai.NaverService;
@Service("mapservice") // = MapServiceImpl mapservice = new MapServiceImpl(); 의 의미.
public class MapServiceImpl implements NaverService{
	
//	@Override
//	public String test(String input) {
//		HashMap<String, String> map = new HashMap();
//		map.put("이름이 뭐니?", "클로버야");
//		map.put("무슨 일을 하니?", "ai 서비스 관련 일을 해");
//		map.put("멋진 일을 하는구나", "고마워");
//		map.put("난 훌륭한 개발자가 될거야", "넌 할 수 있어");
//		map.put("잘 자", "내꿈꿔");
//		
//		String result = null;
//		if(map.get(input) != null) {
//			result = map.get(input); 
//		}
//		else {
//			result = "답변할 수 없는 질문입니다.";
//		}
//		return result;
//	}
	
	//강사님 풀이------------------------------------------------------------------------------
	HashMap<String, String> map = new HashMap();
	public MapServiceImpl() {
		map.put("이름이 뭐니?", "클로버야");
		map.put("무슨 일을 하니?", "ai 서비스 관련 일을 해");
		map.put("멋진 일을 하는구나", "고마워");
		map.put("난 훌륭한 개발자가 될거야", "넌 할 수 있어");
		map.put("잘 자", "내꿈꿔");
	}
	
	@Override
	public String test(String input) {
		String response = map.get(input);
		if(response == null) {
			response = "아직은 저도 몰라요";
		}
		return response;
	}
	//--------------------------------------------------------------------------------------
	
}//class
