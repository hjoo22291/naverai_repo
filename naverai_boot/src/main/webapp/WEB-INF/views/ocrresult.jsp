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
	var json = JSON.parse( '${ocrresult}' );
	//$("#output").html(JSON.stringify(json) );// JSON -> String 객체변환 : JSON.stringify <-> String -> JSON : JSON.parse
	
	let mycanvas = document.getElementById("ocrcanvas");
	let mycontext = mycanvas.getContext("2d");
	let myimage = new Image();
	myimage.src = "/naverimages/${param.image}";
	myimage.onload = function(){ //이미지가 로드가 된 후 실행
		
		//이미지파일 가로크기가 캔버스 가로보다 크면 이미지 크기에 맞춰라	
		if(myimage.width > mycanvas.width || myimage.height > mycanvas.height ) {
			mycanvas.width = myimage.width;			
			mycanvas.height = myimage.height;			
		}

		mycontext.drawImage(myimage, 0, 0, myimage.width, myimage.height);	
		
		//이미지 글씨만 뽑아내기
		let fieldslist = json.images[0].fields;//단어 갯수만큼의 배열
		for(let i in fieldslist) {
			if(fieldslist[i].lineBreak == true) {
				$("#output2").append(fieldslist[i].inferText + "<br>");				
			}
			else {
				$("#output2").append(fieldslist[i].inferText + "&nbsp;");								
			}
			
			//이미지 글씨에 박스그리기
			var x = fieldslist[i].boundingPoly.vertices[0].x; //단어 시작 x좌표
			var y = fieldslist[i].boundingPoly.vertices[0].y; //단어 시작 y좌표
			var width = fieldslist[i].boundingPoly.vertices[2].x - x;
			var height = fieldslist[i].boundingPoly.vertices[2].y - y;
			
			mycontext.strokeStyle="blue";
	        mycontext.lineWidth=2;
			mycontext.strokeRect(x, y, width, height);//(x좌표, y좌표, width(가로길이), height(세로길이))
			
		}//for
		
		
	};//myimage.onload
	
});//ready
</script>
</head>
<body>
<%-- <h3>${ocrresult }</h3> --%>
<div id="output" style="border : 2px solid orange"></div>
<div id="output2" style="border : 2px solid green"></div>
<canvas id="ocrcanvas" style="border : 2px solid blue" width="500" height="500"></canvas>
</body>
</html>