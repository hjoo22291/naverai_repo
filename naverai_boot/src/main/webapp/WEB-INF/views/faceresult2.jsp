<%@page import="java.math.BigDecimal"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3>${faceresult2 }</h3>
<%
String faceresult2 = (String)request.getAttribute("faceresult2");
JSONObject total = new JSONObject(faceresult2); //json 형태로 바꾸겠다. ()안에 것을.
JSONObject info = (JSONObject)total.get("info"); //info라는 변수를 찾자.
int faceCount = (Integer)info.get("faceCount"); //info에서 faceCount값을 찾자

JSONArray faces  = (JSONArray)total.get("faces"); //info라는 변수를 찾자.
//성별, 나이, 감정, 포즈 출력 
for(int i = 0; i < faces.length(); i++){
	JSONObject oneperson = (JSONObject)faces.get(i); //faces.get(i); = i번째 정보 = 한 사람의 정보
	JSONObject gender = (JSONObject)oneperson.get("gender");
	String gender_value = (String)gender.get("value");
	BigDecimal gender_conf = (BigDecimal)gender.get("confidence");
	double gender_conf_double = gender_conf.doubleValue();
	
	JSONObject age = (JSONObject)oneperson.get("age");
	String age_value = (String)age.get("value");
	
	JSONObject emotion = (JSONObject)oneperson.get("emotion");
	String emotion_value = (String)emotion.get("value");
	
	JSONObject pose = (JSONObject)oneperson.get("pose");
	String pose_value = (String)pose.get("value");
	
	out.println("<h3>" + (i+1) + "번째 얼굴의 성별 = " + gender_value + ", 정확도 = " + gender_conf_double + "</h3>" );
	out.println("<h3>" + (i+1) + "번째 얼굴의 나이 = " + age_value + "</h3>" );
	out.println("<h3>" + (i+1) + "번째 얼굴의 감정 = " + emotion_value + "</h3>" );
	out.println("<h3>" + (i+1) + "번째 얼굴의 얼굴방향 = " + pose_value + "</h3>" );
	
	//랜드마크(눈코입위치)값 - 항상 값이 있진 않음. 있을때는 출력하고 없으면 출력X ->JSON은 null 자체도 스트링으로 인식.  	
	if(!oneperson.get("landmark").equals(null)) {
		JSONObject landmark = (JSONObject)oneperson.get("landmark");
		JSONObject nose = (JSONObject)landmark.get("nose");
		out.println("<h3> 코위치 x = " + (Integer)nose.get("x") + ", y = " + (Integer)nose.get("y") + "</h3>");		
	}
	else {
		out.println("<h3> 눈코입의 위치를 파악할 수 없습니다. </h3>");
	}
	
}//for


%>
<h3>총 <%=faceCount %>명의 얼굴을 찾았습니다.</h3>
</body>
</html>