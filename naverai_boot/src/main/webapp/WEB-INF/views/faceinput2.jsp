<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<c:forEach items="${filelist}" var="filename">
<h3>${filename}</h3>
<a href="/faceresult2?image=${filename}">${filename}</a>
<a href="/faceresult2?image=${filename}"><img src="/naverimages/${filename}" width="100" height=100></a>
</c:forEach> 

</body>
</html>