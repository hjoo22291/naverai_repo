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
<h3>${sttresult }</h3>
<audio id="mp3" src="/naverimages/${param.image }" controls></audio>
<script>
document.getElementById("mp3").play(); //자동재생
</script>
</body>
</html>