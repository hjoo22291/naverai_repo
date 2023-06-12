<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- <script src="http://localhost:8063/js/jquery-3.6.4.min.js"></script> -->
<!-- 방법 1)js파일을 naverai_boot안에 복사하지않고 firstboot도 동시에 실행시키고 거기있는 js를 갖다 써도됨.(포트번호 다른경우) -->
<script src="/js/jquery-3.6.4.min.js"></script>
<!-- 방법 2)js파일을 naverai_boot안에 복사하기. 복사할위치 : src/main/resources 안에 static 폴더안에 js폴더만들고 그안에 jquery파일 -->
<script>
<!-- 방법1 - 모델을 json객체 변환 - 자바api(pom.xml 추가) -> 얼굴 분석 서비스 할때 한 방식 -->
<!-- 방법2 - 모델을 json객체 변환 - 자바스크립트 -> 지금 쓸 방식(사물 인식 서비스) -->
$(document).ready(function(){
   var json = JSON.parse('${objectresult}');
   //몇개 찾았는지
   $("#count").html("<h3>"+json.predictions[0].num_detections+"개의 사물 탐지</h3>");
   
   for(var i=0; i<json.predictions[0].num_detections; i++){
 	  //찾은것들 각각 이름 출력
      $("#names").append(
      json.predictions[0].detection_names[i]+" - " +
      parseInt(parseFloat(json.predictions[0].detection_scores[i]) * 100)+"% <br>"
      );
 	  
 	  //위치정보 가져오기
 	  var x1 = json.predictions[0].detection_boxes[i][0];
 	  var y1 = json.predictions[0].detection_boxes[i][1];
 	  var x2 = json.predictions[0].detection_boxes[i][2];
 	  var y2 = json.predictions[0].detection_boxes[i][3];
 	  $("#boxes").append( "(x1, y1) = (" + x1+ ", "+ y1 + ") / (x2, y2) = (" + x2 +", "+ y2 +") <br>" );
 	  
   }//for
   
	let mycanvas = document.getElementById("objectcanvas");
	let mycontext= mycanvas.getContext("2d");
	
	let objectimage = new Image();
	objectimage.src = "/naverimages/${param.image}";//url 통신 이미지 다운로드 시간 대기
	objectimage.onload = function(){ //이미지 로드 된 후에 실행하게 하기.
		
		if(objectimage.width > mycanvas.width || objectimage > mycanvas.height ) {
			mycanvas.width = objectimage.width;			
			mycanvas.height = objectimage.height;			
		}
		mycontext.drawImage(objectimage, 0, 0, objectimage.width, objectimage.height);
		
		var boxes = json.predictions[0].detection_boxes; //배열
		//과제 - 각각 표시 색상 다르게 만들기.
 	  	let colors = ['red', 'orange', 'yellow', "lime", "skyblue" , "navy", "purple"];
		for(var i = 0; i < boxes.length; i++) {
	 	/* API 설명에는 x , y 좌표 순서라고 하는데 실제 결과보면 안맞음. 아마 y, x 좌표 순서인듯..
	 		var x1 = boxes[i][0] * objectimage.width;
	 	  	var y1 = boxes[i][1] * objectimage.height;
	 	  	var x2 = boxes[i][2] * objectimage.width;;
	 	  	var y2 = boxes[i][3] * objectimage.height; */
	 	  	
	 	  	//x,y좌표 반대로 다시주기.
	 	  	var y1 = boxes[i][0] * objectimage.height;
	 	  	var x1 = boxes[i][1] * objectimage.width;
	 	  	var y2 = boxes[i][2] * objectimage.height;
	 	  	var x2 = boxes[i][3] * objectimage.width;
	 	  	
	 	  	//사각형으로 표시하기
	 	  	mycontext.lineWidth = 3;
			mycontext.strokeStyle = colors[i%colors.length];
	 	  	mycontext.strokeRect(x1, y1, (x2-x1), (y2-y1));
	 	  	
	 	  	//사각형으로 표시한 물체 이름 텍스트로 넣기
	 	  	mycontext.fillStyle= colors[i%colors.length];
	 	  	mycontext.font="15px bold"
	 	  	mycontext.fillText(json.predictions[0].detection_names[i], x1, (y1-5))
	 		
		}//for	
		
	}//objectimage.onload
	
})//ready
</script>
</head>
<body>
<h3>${objectresult }</h3>

<div id="count" style="border : 2px solid green" ></div>
<div id="names" style="border : 2px solid lime" ></div>
<div id="boxes" style="border : 2px solid orange" ></div>
<canvas id="objectcanvas" width="500" height="500" style="border:2px solid pink"></canvas>
</body>
</html>