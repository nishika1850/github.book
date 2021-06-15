<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.MyDBAccess"%>
<%
	// Servletから名前データの受け取りしたい
	request.setCharacterEncoding("UTF8");
	String username = (String) session.getAttribute("username");
    String lastlogin = (String) session.getAttribute("lastlogin");

	String t_book = (String) request.getAttribute("t_book");

	// MyDBAccess のインスタンスを生成する
	MyDBAccess db = new MyDBAccess();

	// データベースへのアクセス
	db.open();

	// データベースを取得
	ResultSet rs = db.getResultSet(t_book);

	String bookid="";
	String bookname="";
	String bookwriter="";
	String bookvol="";
	String bookreleasedate="";

	// 取得された各結果に対しての処理
		while(rs.next()) {
			bookid=rs.getString("book_id");
			bookname=rs.getString("book_name");
			bookwriter=rs.getString("book_writer");
			bookvol=rs.getString("book_vol");
			bookreleasedate=rs.getString("book_release_date");
		}

%>

<!DOCTYPE html>
<html >
	<head>
		<title>MyBookshelf</title>
		<meta charset="UTF-8">
		<link rel="stylesheet" href="book_update.css">
		<link href="https://fonts.googleapis.com/css?family=Caveat rel="stylesheet">
        <script>
			function fnc_submit(form) {
				//valueをhiddenにセット
				var bookid = document.getElementById("bookid");
				formname.updateid.value = bookid;

				var bookname = document.getElementById("bookname");
				formname.updatename.value = bookname;

				var bookwriter = document.getElementById("bookwriter");
				formname.updatewriter.value = bookwriter;

				var bookvol = document.getElementById("bookvol");
				formname.updatevol.value = bookvol;

				var bookreleasedate = document.getElementById("bookreleasedate");
				formname.updatereleasedate.value = bookreleasedate;

				//書籍タイトル入力チェック
    			if(bookname.value==""){
		     		alert("書籍タイトルは必須入力です");
		     		return;
    			}

    			//所持巻数入力チェック
    			var flag1 = 0;
    			// 設定開始（チェックする項目を設定してください）
    			if(document.formname.bookvol.value.match(/[^0-9]+/)){
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
    			if(document.formname.bookreleasedate.value.match(/[^0-9,/,-]+/)){
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
			<h1>Update</h1>
			<hr>
		</header>
		<form name="formname" action="DataUpdateClass" method="post" enctype="multipart/form-data">
			<div class="box1">
			<dl>
				<dt><strong>BookID</strong></dt>
					<dd><input type="text" readonly="readonly" id="bookid" name="bookid" value="<%=bookid%>"/>※BookIDは変更不可</dd>
				<dt><strong>BookTitle</strong></dt>
					<dd><input type="text" id="bookname" name="bookname" value="<%=bookname%>"></dd>
				<dt><strong>writer</strong></dt>
					<dd><input type="text" id="bookwriter" name="bookwriter" value="<%=bookwriter%>"></dd>
				<dt><strong>get vol</strong></dt>
					<dd><input type="text" id="bookvol" name="bookvol" value="<%=bookvol%>"></dd>
				<dt><strong>Last release</strong></dt>
					<dd><input type="text" id="bookreleasedate" name="bookreleasedate" value="<%=bookreleasedate%>"></dd>
				<dt><strong>pic</strong></dt>
					<dd><input type="file" name="pict" accept="image/*" onchange="previewImage(this);"></dd>
			</dl>
			<!-- 👇ここにプレビュー画像を追加する -->
			<img id="preview" src="" width="75px" height="75px">
			</div>
		<p>
			<input type="hidden" name="updateid" value="">
			<input type="hidden" name="updatename" value="">
			<input type="hidden" name="updatewriter" value="">
			<input type="hidden" name="updatevol" value="">
			<input type="hidden" name="updatereleasedate" value="">

			<input type="button" id="updatebutton" value="update" onClick=" fnc_submit(this.form)">
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
