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
<h3>${faceresult }</h3> <!-- 결과 전체내용 그대로 출력 -->
<!--  결과 json형태
{"info":{
	"size":{"width":500,"height":500}, //이미지 사진 크기
	"faceCount":1}, //발견된 얼굴 1개
"faces":[{
"celebrity":{"value":"김현주","confidence":0.16284} //이 사람을 닮았다. 16%정도.
}]} 
 -->
<!-- 자바 언어 String에서 자바스크립트 객체인 json타입으로 변환 필요. -- json 데이터 parsing을 위한 라이브러리 pom.xml에 추가 -->
<%
String faceresult = (String)request.getAttribute("faceresult"); //faceresult결과를 가져와라.
JSONObject total = new JSONObject(faceresult); //json 형태로 바꾸겠다. ()안에 것을.
JSONObject info = (JSONObject)total.get("info"); //info라는 변수를 찾자.
int faceCount = (Integer)info.get("faceCount"); //info에서 faceCount값을 찾자

JSONArray faces = (JSONArray)total.get("faces"); //faces라는 변수를 찾자. - faces 배열형태니까 배열로 받기.
for(int i = 0; i<faces.length(); i++){
	JSONObject oneFace = (JSONObject)faces.get(i); //[{"":{},] 이거 하나 가져오는것
	JSONObject celebrity = (JSONObject)oneFace.get("celebrity"); //그 안에서 celebrity값 가져오기
	String name = (String)celebrity.get("value"); //그 안의 value값 = 연예인 이름 가져오기
	BigDecimal confidence = (BigDecimal)celebrity.get("confidence"); //0.16284 이 값 가져오는것.
	double confidenceDouble = confidence.doubleValue();
	if(confidenceDouble >= 0.7) { //정확도 70%이상만 출력하도록 해보기
		out.println("<h3>"+ name + " 유명인을 " + Math.round(confidenceDouble*100) + "퍼센트로 닮았습니다.</h3>");	
	}
}

%>

<h3><%= faceCount %>명의 얼굴을 찾았습니다.</h3>
</body>
</html>