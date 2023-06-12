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
	//구현
});
</script>
</head>
<body>
<h3>답변 : ${text }</h3>
<audio id="reply" src="/naverimages/${ttsresult}" controls></audio>
<script>
document.getElementById("reply").play(); //자동재생
</script>
</body>
</html>