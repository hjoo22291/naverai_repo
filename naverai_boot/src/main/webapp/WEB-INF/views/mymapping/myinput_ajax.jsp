<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/js/jquery-3.6.4.min.js"></script>
<script>
$(document).ready(function(){
	$("#ajaxbtn").on('click', function(){
		$.ajax({
			url : 'myoutput_ajax',
			data : {'input' : $("#input").val()},
			type : 'get',
			dataType : 'json',
			success : function(server){
				$("#response").html(server.text);
				$("#reply").attr('src', "/naverimages/"+server.ttsresult);
				$("#reply")[0].play(); //자동재생 - 값이 하나여도 배열형태로 들어오기때문에 배열 첫번째값이라고 표시해줘야함.. by.안하하
			},
			error : function(e){
				alert(e);
			}
			
		});//ajax
	});//ajaxbtn click


});//ready
</script>
</head>
<body>
<h2>질문을 입력해주세요.</h2>
<input type="text" id="input" name="input" >
<input type=button id="ajaxbtn" value="대화">
<br>
<h3>답변 : <div id="response"></div></h3>
<audio id="reply" src="" controls></audio>

</body>
</html>