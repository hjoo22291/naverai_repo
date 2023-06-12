<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
a {
text-decoration : none;
color : black;
size : 15px;
}
li {
list-style-type: decimal;
margin : 5px;
}
</style>
<script src="/js/jquery-3.6.4.min.js"></script>
<script>
$(document).ready(function(){
	//구현
});
</script>
</head>
<body>
<h2> 서비스 목록 </h2>
<ul>
	<li><a href="faceinput">유명인 닮은꼴 서비스</a></li>
	<li><a href="faceinput2">얼굴 분석 서비스</a></li>
	<li><a href="objectinput">객체 탐지 서비스</a></li>
	<li><a href="poseinput">자세 분석 서비스</a></li>
	<li><a href="sttinput">STT 서비스(mp3를 txt로 변환)</a></li>
	<li><a href="ttsinput">TTS 서비스(txt를 mp3로 변환)</a></li>
	<li><a href="myinput">My 서비스(ai에게 질문하고 음성으로 답변받기)</a></li>
	<li><a href="myinput_ajax">My 서비스_ajax(ai에게 질문하고 음성으로 답변받기)</a></li>
	<li><a href="ocrinput">OCR 서비스</a></li>
	<li><a href="chatbotrequest">Chatbot 서비스(기본답변)</a></li>
	<li><a href="chatbotajaxstart">Chatbot 서비스_ajax(기본답변)</a></li>
	<li><a href="chatbotajax">Chatbot 서비스_ajax(멀티답변)</a></li>
</ul>
</body>
</html>