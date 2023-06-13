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
	
	//내맘대로 추가) 입력창 포커스 + 엔터치면 "답변" 버튼 눌리게
	$("#request").focus();
	const request= document.getElementById("request");
	request.addEventListener("keydown", function(event) {
	    if (event.keyCode === 13) {
	      event.preventDefault(); 
	      $("#event1").click(); 
	    }
    });//keydown

	
	//1.type button 클릭하면 request질문을 response 붙여넣는다.
	$("input:button").on('click', function(){
		$("#response").append("질문 : " + $("#request").val() + "<br>");
		//2. 컨트롤러로 전송
		$.ajax({
			url : "/chatbotajaxprocess",
			data : {"request" : $("#request").val() , "event" : $(this).val()},
			type : 'get',
			dataType : 'json',
			success : function(server){
				let bubbles = server.bubbles;
				for(let b in bubbles){
					//1.기본(텍스트/ 텍스트+url)
					if(bubbles[b].type=='text'){
						$("#response").append("기본답변 : " + bubbles[b].data.description + "<br>");
						if(bubbles[b].data.url != null){ //url 있다면
							$("#response").append
							('<a href=' + bubbles[b].data.url + '>' + bubbles[b].data.description + '</a><br>');
						}
						//추가 - 텍스트답변 음성으로 출력하기
						$.ajax({
							url : 'chatbottts',
							data : {'text' : bubbles[b].data.description },
							type : 'get',
							dataType : 'json',
							success : function(server){
								//alert(server.mp3);
								//$("#tts").attr('src', "/naverimages/" + server.mp3);
								//$("#tts")[0].play();
								
								//강사님 풀이
								let audio = document.getElementById("tts");
								audio.src = "/naverimages/" + server.mp3;
								audio.volume = 0.3; //내가 추가함. 소리 너무커서..
								audio.play();
							},
							error : function(e){
								alert(e);
							}
						});//ajax
						
						//추가 - 피자주문///////////////////////////////////////////////////////////////////////
						//주문 내역에따라 총 금액 계산해서 보여주도록 만들기
						var order_reply = bubbles[b].data.description;
						if(order_reply.indexOf("주문하셨습니다.") >= 0) { //대답에 "주문하셨습니다."란 글자가 포함되어있다면
							//결과 예시 : 콤비네이션피자 대 주문하셨습니다. 01011111111 으로 연락드리겠습니다. 감사합니다.
							var split_result = order_reply.split(" "); //공백을 기준으로 문자열 분리. 결과 배열
							var kind = split_result[0]; //피자 종류
							var size = split_result[1]; //피자 사이즈
							var phone = split_result[3]; //핸드폰번호
							var kinds = ["콤비네이션피자", "소세지크림치즈피자", "파인애플피자"];
							var prices = [10000, 15000, 12000];
							//소 - 기본가격, 중 - 기본가격+2000원, 대 - +5000원, 특대 - +10000원
							var totalprice = 0;
							for(let i = 0; i < kinds.length; i++){
								if(kind == kinds[i]){
									if(size == "소"){
										totalprice = prices[i];
									}
									else if(size == "중"){
										totalprice = prices[i] + 2000;
									}
									else if(size == "대"){
										totalprice = prices[i] + 5000;
									}
									else{
										totalprice = prices[i] + 10000;										
									}
								}
							}
							$("#response").append("총 지불 가격 : " + totalprice);
							
							//피자db에 추가
							$.ajax({
								url : 'pizzaorder',
								data : {"kind" : kind, "size" : size, "phone" : phone, "price" : totalprice},
								type : 'get',
								dataType : 'json',
								success : function(server){
									alert("주문내역 저장 완료!");
								},
								error : function(e) {
									alert(e);
								}
							});//ajax
						}//피자주문end

					}//기본답변 end
					//이미지이거나 멀티링크
					else if(bubbles[b].type=='template'){
						//2.이미지(이미지)
						if(bubbles[b].data.cover.type == 'image'){
							$("#response").append
							('<img src=' + bubbles[b].data.cover.data.imageUrl + ' width=200 height=200 ><br>');
						}
						//3.멀티링크(url) 
						else if(bubbles[b].data.cover.type == 'text'){
							$("#response").append("멀티링크답변 : " + bubbles[b].data.cover.data.description + "<br>");
						}
						//4.이미지+멀티링크 공통(url)
						for(let c in bubbles[b].data.contentTable){
							for(let d in bubbles[b].data.contentTable[c]){
								let link = bubbles[b].data.contentTable[c][d].data.title;
								let href = bubbles[b].data.contentTable[c][d].data.data.action.data.url;
								$("#response").append('<a href=' + href +'> ' + link +'</a><br>');
							}
						}
					
					}
				
				}//for(let b in bubbls) end
			},
			error : function(e){
				alert(e);
			}
		});//ajax
		
		//내맘대로추가)다하면 내용 지우기
		$("#request").val("");
		$("#request").focus();
		
	});//input:button
	
});
</script>
</head>
<body>

질문 : <input type=text id="request" value="">
<input type=button value="답변" id="event1">
<input type=button value="웰컴메세지" id="event2">
<button id="record">음성질문녹음시작</button>
<button id="stop">음성질문녹음종료</button>
<div id="sound"></div>
<br>
대화내용 : <div id="response" style="border : 2px solid aqua" ></div>
음성답변 : <audio id="tts" src="" controls="controls"></audio>

<script>
let record = document.getElementById("record");
let stop = document.getElementById("stop");
let sound = document.getElementById("sound");

//브라우저 녹음기나 카메라 사용 지원여부
if(navigator.mediaDevices) {
	console.log("지원가능");
	var constraint = {"audio" : true}; //녹음 기능 활성화
}
//녹음 진행 동안 blob 객체가 생성됨.(2진수들 모아놓은 객체) - 녹음종료 - mp3파일 생성&저장
let chunks = [];
navigator.mediaDevices.getUserMedia(constraint).then(function(stream){
	var mediaRecorder = new MediaRecorder(stream); //녹음기 준비
	//녹음버튼 누르면 녹음시작
	record.onclick = function(){
		mediaRecorder.start();
		record.style.color = "red";
		record.style.backgroundColor = "blue";		
	}
	//stop버튼 누르면 녹음종료
	stop.onclick = function(){
		mediaRecorder.stop();
		record.style.color = "";
		record.style.backgroundColor = "";		
	}
	
	//녹음 시작상태이면 chunks에 녹음 데이터 저장해라
	mediaRecorder.ondataavailable = function(d){
		chunks.push(d.data);
	}
	
	//녹음정지상태이면
	mediaRecorder.onstop = function(){
		//audio태그 추가해라
		var audio = document.createElement("audio");//<audio></audio>
		audio.setAttribute("controls", ""); 
		audio.controls = true; //<audio controls></audio>
		
		sound.replaceChildren(audio);
		sound.appendChild(audio); //<div> <audio controls></audio> </div>
		
		var blob = new Blob(chunks, {"type" : "audio/mp3"});
		var mp3url = URL.createObjectURL(blob);
		audio.src = mp3url;
		
		//다음 녹음 위해 chunks 초기화
		chunks = [];
		
		//중간에  br태그 추가(내맘대로)
		var br = document.createElement("br");//<a></a>
		sound.appendChild(br); //<br>태그 추가
		
		//a태그 만들기
		var a = document.createElement("a");//<a></a>
		sound.appendChild(a); //<div> <audio controls></audio> <br> <a></a> </div>
		a.href = mp3url; //<div> <audio controls></audio> <br> <a href=mp3파일명></a> </div>
		a.innerHTML = "파일로 저장"; //<div> <audio controls></audio> <br> <a href=mp3파일명> 파일로 저장 </a> </div>
		a.download = "a.mp3"; //a.mp3라는 파일명으로 다운로드. a 태그 안에 download속성있음. 
		
		//스프링부트 서버 요청 a.mp3 upload+ajax
		var formData = new FormData();
		formData.append("file1", blob,"a.mp3"); //file1에 blob정보를 담아 a.mp3라는 이름으로 만들어라.
		$.ajax({
			url : "mp3upload",
			data : formData,
			type : "post",
			processData : false,
			contentType : false,
			success : function(server){
				//alert(server);
				$.ajax({
					url : "/chatbotstt",
					data : {"mp3file" : "a.mp3"},
					type : "get",
					dataType : "json",
					success : function(server){
						$("#request").val(server.text);
						//내맘대로 추가) 바로 클릭까지 이어지게
						$("#event1").click();
					},
					error : function(e){
						alert(e);
					}
				});//ajax
			},
			error : function(e){
				alert(e);
			}
		});
		
	}
	
})//then end(문장끝나지않음. 밑에까지 한문장)
.catch(function(err){console.log("오류발생 : " + err)});//catch end


</script>

</body>
</html>