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
	var json = JSON.parse( '${poseresult}' );
	//json.predictions[0]= 한사람. 한사람의 정보 안에 0~17번 인덱스까지 있음.
/* 	$("#posecanvas") - jquery객체 - jqury객체는 뒤에 getContext 못씀. -> $("#posecanvas").get(0) - jquery를 자바스크립트 객체로 변환.
	document.getElementById("posecanvas") - 자바 스크립트 객체. 뒤에 getContext("2d")등을 붙일수있음. */
	
	let mycanvas = document.getElementById("posecanvas");
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
		var body_inform = ["코", "목", "오른쪽 어깨", "오른쪽 팔굼치", "오른쪽 손목", "왼쪽 어깨", "왼쪽 팔꿈치", "왼쪽 손목",
			"오른쪽 엉덩이", "오른쪽 무릎", "오른쪽 발목", "왼쪽 엉덩이", "왼쪽 무릎", "왼쪽 발목", "오른쪽 눈", "왼쪽 눈", "오른쪽 귀", "왼쪽 귀"];
		let colors = ['red', 'orange', 'yellow', "lime", "skyblue" , "navy", "purple"];
		//한명의 경우. 각 부위마다 표시색상 변경
/*  		for(var i = 0; i < body_inform.length; i++){
			if(json.predictions[0][i] != null) {
			var x = json.predictions[0][i].x * myimage.width; //첫번째사람의 0번인덱스 = 코 위치의 x좌표
			var y = json.predictions[0][i].y * myimage.height; //첫번째사람의 0번인덱스 = 코 위치의 y좌표
			
	 	  	//사각형으로 표시한 물체 이름 텍스트로 넣기
	 	  	mycontext.fillStyle=colors[i%colors.length];
	 	  	mycontext.font="13px bold"
			mycontext.fillText(body_inform[i], x, y);
			//원으로 표시하기
			mycontext.beginPath();
			mycontext.arc(x, y, 3, 0, 2*Math.PI);
			//mycontext.stroke(); //속이 빈 원
			mycontext.fill(); //색칠된 원
			
	 	  	}//if */
	 	  
	 	//여러명일때. 각부위 표시 색상 바꾸기
	 	for(var j = 0; j < json.predictions.length; j++) {
	 		for(var i = 0; i < body_inform.length; i++){
				if(json.predictions[j][i] != null) {
					var x = json.predictions[j][i].x * myimage.width; //첫번째사람의 0번인덱스 = 코 위치의 x좌표
					var y = json.predictions[j][i].y * myimage.height; //첫번째사람의 0번인덱스 = 코 위치의 y좌표
					
			 	  	//사각형으로 표시한 물체 이름 텍스트로 넣기
			 	  	mycontext.fillStyle=colors[i%colors.length];
			 	  	mycontext.font="13px bold"
					mycontext.fillText(body_inform[i], x, y);
					
					//원으로 표시하기
					mycontext.beginPath();
					mycontext.arc(x, y, 3, 0, 2*Math.PI);
					mycontext.fill();
		 	  	}//if
			}//inner for
	 	}//outer for
		
		
		
		
		
		
	};
	
});//ready
</script>
</head>
<body>
<%-- <h3>${poseresult }</h3> --%>
<div id="output" style="border : 2px solid orange"></div>
<canvas id="posecanvas" style="border : 2px solid green" width="500" height="500"></canvas>
</body>
</html>