<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
window.onload=function(){
	let mycanvas = document.getElementById("facecanvas");
	let mycontext = mycanvas.getContext("2d");
	
	let faceimage = new Image();
	faceimage.src="/naverimages/${param.image}"; //url통신 이미지 다운로드 대기시간
	faceimage.onload = function(){
		mycontext.drawImage(faceimage, 0, 0, faceimage.width, faceimage.height);
		//얼굴좌표 필요
		<%
		String faceresult2 = (String)request.getAttribute("faceresult2");
		JSONObject total = new JSONObject(faceresult2); //json 형태로 바꾸겠다. ()안에 것을.
		JSONArray faces  = (JSONArray)total.get("faces"); //info라는 변수를 찾자.
		//얼굴크기 : faces[i].roi.x / faces[i].y 
		
		for(int i = 0; i < faces.length(); i++){
			JSONObject oneperson = (JSONObject)faces.get(i); //faces.get(i); = i번째 정보 = 한 사람의 정보
			JSONObject roi = (JSONObject)oneperson.get("roi");
			int x = (Integer)roi.get("x");
			int y = (Integer)roi.get("y");
			int width = (Integer)roi.get("width");
			int height = (Integer)roi.get("height");
		%>
		//얼굴 위치에 네모칸 그려주기	
		mycontext.lineWidth = 3;
		mycontext.strokeStyle = "pink";
		mycontext.strokeRect(<%=x%>, <%=y%>, <%=width%>, <%=height%>);
		
		//일부 이미지만 이동
		var copyimage = mycontext.getImageData(<%=x%>, <%=y%>, <%=width%>, <%=height%>);
		mycontext.putImageData(copyimage, <%=x%>, <%=y+300%>);
		
		//네모안에 색 채우기
		mycontext.fillStyle = "orange";
		mycontext.fillRect(<%=x%>, <%=y%>, <%=width%>, <%=height%>);
		
		<%
		}//for
		%>
	}//faceimage.onload
	
};

</script>

</head>
<body>

<canvas id="facecanvas" width="800" height="800" style="border : 2px solid pink"></canvas>

</body>
</html>