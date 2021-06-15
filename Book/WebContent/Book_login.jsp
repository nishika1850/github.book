<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
	// Servletのデータ受け取り
 	request.setCharacterEncoding("UTF8");
    String message ="user IDとpasswordを入力してください";
    String moji= (String) request.getAttribute("message");
    	if(!(moji==null)){
	    	message ="<font color=\"red\">"+moji+"</font>";
		}
%>
<!DOCTYPE html>
<html >
	<head>
		<meta charset="UTF-8">
		<link rel="stylesheet"  href="${pageContext.request.contextPath}/book_login.css">
		<link href="https://fonts.googleapis.com/css?family=Caveat rel="stylesheet">
	        <script>
		    	function fnc_submit(form) {

		   			//IDとパスワード必須入力チェック
		     		var userid = document.getElementById("userid");
		     		var userpass = document.getElementById("userpass");
				     	if(userid.value==""){
				     		alert("user IDを入力してください");
				     	}
				     	if(userpass.value==""){
				     		alert("passwordを入力してください");
				     		return;
				     	}

				    //IDの半角チェック
					var str=userid.value; /* 入力値 */
					for (var i=0; i<str.length; i++) {
					/* 1文字ずつ文字コードをエスケープし、その長さが4文字未満なら半角 */
						var len=escape(str.charAt(i)).length;
						if (len<4){
							}else{
								alert("半角以外の文字が含まれています");
								return;
		            	}
					}

					//ユーザーＩＤ 文字数チェック
					if (userid.value.length < 8){
						alert('8桁のuser IDを入力してください');
						return;
					}

					//パスワード 文字数チェック
					if (userpass.value.length < 4){
						alert('4桁のpasswordを入力してください');
						return;
					}
		    		// submit
		    		form.submit();

		     	}
	        </script>
	</head>
	<title>MyBookshelf</title>
	<body>
		<header>
			<h1>MyBookshelf Login</h1>
			<hr>
		</header>
			<form name="formname" action="LoginSearchClass" method="post">
				<p id="p1">
					&emsp;&emsp;<%=message %>
				</p>
				<dl>
					<dt><strong>user ID</strong></dt>
					<dd><input type="text" id="userid" name="userid" value="" placeholder="8桁のuser IDを入力"></dd>
					<dt><strong>password</strong></dt>
					<dd><input type="password" id="userpass" name="userpass" placeholder="4桁のpasswordを入力"></dd>
				</dl>
				<p>
					<input type="button" id="loginbutton" value="login" onClick="fnc_submit(this.form)">
					<input type="reset" id="resetbutton" value="reset">
				</p>
			</form>
			<footer>
				<div class="button_wrapper">
					<input type="button" id="closebutton" value="close" onClick="window.close();">
				</div>
			</footer>
			<p id="p3"><strong>
			<script>
			   	// 時間帯別メッセージ設定
				var msg1 = 'Display by time zone　Good morning'; // 時間帯1
				var msg2 = 'Display by time zone　Hello'; // 時間帯2
				var msg3 = 'Display by time zone　Have you eaten lunch yet?'; // 時間帯3
				var msg4 = 'Display by time zone　Hello';  // 時間帯4
				var msg5 = 'Display by time zone　Good evening'; // 時間帯5
				var msg6 = 'Display by time zone　Don\'t stay up late'; // 時間帯6

				var now = new Date();
				var hour = now.getHours();
				// 時間帯1 5:00 ～ 9:59
				if(hour >= 5 && hour <= 9){
					document.write(msg1);
				}

				// 時間帯2 10:00 ～ 11:59
				else if(hour >= 10 && hour <= 11){
					document.write(msg2);
				}

				// 時間帯3 12:00 ～ 13:59
				else if(hour >= 12 && hour <= 13){
					document.write(msg3);
				}

				// 時間帯4 14:00 ～ 16:59
				else if(hour >= 14 && hour <= 16){
					document.write(msg4);
				}

				// 時間帯5 17:00 ～ 23:59
				else if(hour >= 17 && hour <= 23){
					document.write(msg5);
				}

				// 時間帯6 0:00 ～ 4:59
				else{
					document.write(msg6);
				}
			</script>
			</strong>
			</p>
	</body>
</html>