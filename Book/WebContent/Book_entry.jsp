<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.MyDBAccess"%>
<%
	// Servletから名前データの受け取りしたい
	request.setCharacterEncoding("UTF8");
	String username = (String) session.getAttribute("username");
    String lastlogin = (String) session.getAttribute("lastlogin");

%>
<!DOCTYPE html>
<html>
	<head>
		<title>MyBookshelf</title>
		<meta charset="UTF-8">
		<link rel="stylesheet" href="book_entry.css">
		<link href="https://fonts.googleapis.com/css?family=Caveat rel="stylesheet">
        <script>
    		function fnc_submit(form) {
    			//書籍タイトル入力チェック
    			var bookname = document.getElementById("bookname");
    			if(bookname.value==""){
		     		alert("書籍タイトルは必須入力です");
		     		return;
    			}

    			//所持巻数入力チェック
    			var flag1 = 0;
    			// 設定開始（チェックする項目を設定してください）
    			if(document.form_entry.bookvol.value.match(/[^0-9]+/)){
    				flag1 = 1;
    			}
    			// 設定終了
    			if(flag1==1){
    				window.alert('所持巻数に数字以外が入力されています'); // 数字以外が入力された場合は警告ダイアログを表示
    				return; // 送信を中止
    			}

    			//最終発売日入力チェック
    			var flag2 = 0;
    			// 設定開始（チェックする項目を設定してください）
    			if(document.form_entry.bookrelease.value.match(/[^0-9,/]+/)){
    				flag2 = 1;
    			}
    			// 設定終了
    			if(flag2==1){
    				window.alert('最終発売日に日付以外が入力されています'); // 数字以外が入力された場合は警告ダイアログを表示
    				return; // 送信を中止
    			}

    			form.submit();

	  		 }

    		function previewImage(obj)
    		{
    			var fileReader = new FileReader();
    			fileReader.onload = (function() {
    				document.getElementById('preview').src = fileReader.result;
    			});
    			fileReader.readAsDataURL(obj.files[0]);
    		}

        </script>
	</head>
	<body>
		<header>
			<div style=text-align:right><strong>こんにちは <%=username %>さん</strong></div>
			<div style=text-align:right><strong>前回ログイン：<%=lastlogin %></strong></div>
			<div style=text-align:right>
			<a href="Book_login.jsp">
				<input type="button" id="logout" value="Logout">
			</a>
			</div>
			<h1>New Entry</h1>
			<hr>
		</header>

		<form name="form_entry" action="EntryBookClass" method="post" enctype="multipart/form-data">
			<div class="box1">

			<dl>
				<dt><strong>BookID</strong></dt>
					<dd><input type="text" id="bookid" name="bookid" readonly="readonly" placeholder="自動入力"></dd>
				<dt><strong>BookTitle</strong></dt>
					<dd><input type="text" id="bookname" name="bookname"  autofocus></dd>
				<dt><strong>writer</strong></dt>
					<dd><input type="text" id="bookwriter" name="bookwriter"></dd>
				<dt><strong>get vol</strong></dt>
					<dd><input type="text" id="bookvol" name="bookvol" placeholder="「巻」の入力不要"></dd>
				<dt><strong>Last release</strong></dt>
					<dd><input type="text" id="bookrelease" name="bookrelease" placeholder="2021/01/01"></dd>
				<dt><strong>pic</strong></dt>
					<dd><input type="file" name="pict" accept="image/*" onchange="previewImage(this);"></dd>
			</dl>
			<!-- 👇ここにプレビュー画像を追加する -->
			<img id="preview" src="" width="75px" height="75px">

			</div>
		<p>
			<input type="button" id="entrybutton" value="entry" onClick="fnc_submit(this.form)">
			<input type="reset" id="resetbutton" value="reset">
		</p>
		</form>

		<footer>
			<div class="button_wrapper">
				<input type="button" id="backbutton" value="back" onClick="window.history.back()">
			</div>
		</footer>
	</body>
</html>