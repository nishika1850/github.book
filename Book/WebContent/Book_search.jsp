<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.MyDBAccess"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
	//-------- Servletから名前データの受け取りしたい-------------
	request.setCharacterEncoding("UTF8");

	//user_name表示
    String username = (String) session.getAttribute("username");
	String namae="ゲスト";
 	if(!(username==null)){
		namae =username ;
	}

	//last_login表示
    String lastlogin = (String) session.getAttribute("lastlogin");
	String login="初めてのログインです";
 	if(!(lastlogin==null)){
		login =lastlogin ;
	}

 	//-------- 検索内容受け取り-------------
	String book_id ="";
	String search_id=(String) request.getAttribute("book_id");
	if(!(search_id==null)){
		book_id=search_id;
	}

	String book_name ="";
	String search_name=(String) request.getAttribute("book_name");
	if(!(search_name==null)){
		book_name=search_name;
	}

	//-------- データベースの中身を全表示するselect文-------------
	String strServlet = (String) request.getAttribute("fromServlet");
	//データベースの中身を全表示するselect文
	//String moji="select * from t_book order by book_id";

	//ページング
	//-------- データベース接続------------------
	//MyDBAccess のインスタンスを生成する
	MyDBAccess db = new MyDBAccess();
	// データベースへのアクセス
	db.open();
	// データベースを取得
	String pages="SELECT COUNT(*) FROM t_book";

	ResultSet rs1 =null;

	try {
		rs1 = db.executeQuery(pages);
	} catch (SQLException e) {
		e.printStackTrace();
	}

	int count=0;
	// 取得された各結果に対しての処理
	while(rs1.next()){
		count = rs1.getInt("count");
	}

	 //countからページ数を割り出す
	String paging="";
	int num=1;
	for(double i=0;i<count/5.0;i++){
		paging+="<li><input type=\"submit\" id=\"page1\" name=\"page1\" value=\""+num+"\">&nbsp;</li>";
		num++;
	}

	//ページ初期表示
	//ページング…↓で1～10出る offset limitで表示上限、countでmax値出る
	String moji="select * from t_book where book_id < 51 order by book_id offset 0 limit 5";
	//選択表示
	String paging_session=(String) request.getAttribute("paging_session");
	if(!(paging_session==null)){
		moji=paging_session;
	}

	if(!(strServlet==null)){
		moji=strServlet;
	}

	// データベースを取得
	try {
		rs1 = db.getResultSet(moji);
	} catch (SQLException e) {
		e.printStackTrace();
	}

	//-------- 一覧テーブル表示------------------
	// データベース一覧表示用のテーブル

	String tableHTML="";


	// 取得された各結果に対しての処理

	try {
		while(rs1.next()) {

		    String id = rs1.getString("book_id"); //書籍IDを取得
		    String name = rs1.getString("book_name"); //書籍タイトルを取得
		    String writer = rs1.getString("book_writer"); //筆者を取得
		    String vol = rs1.getString("book_vol"); //巻数を取得
		    String release = rs1.getString("book_release_date"); //最終発売日を取得
		    String pict = rs1.getString("pict"); //最終発売日を取得

		    if(pict==null){
			    // テーブル用HTMLを作成
			    tableHTML +="<tr><td align=\"center\"><input type=\"radio\" name=\"td1\" value=\""+id+"\" style=\"width:50px;\"></td>"
			    		  + "<td style=\"width:50px;\">" + id + "</td>"
			              + "<td style=\"width:250px;\">" + name + "</td>"
			              + "<td style=\"width:150px;\">" + writer + "</td>"
			              + "<td style=\"width:100px;\">" + vol + "</td>"
			              + "<td style=\"width:150px;\">" + release + "</td>"
			              + "<td style=\"width:150px;\"></th>"
			              +"</tr>";
		    }else{
			    // テーブル用HTMLを作成
			    tableHTML += "<tr><td align=\"center\"><input type=\"radio\" name=\"td1\" value=\""+id+"\" style=\"width:50px;\"></td>"
			    		  + "<td style=\"width:50px;\">" + id + "</td>"
			              + "<td style=\"width:250px;\">" + name + "</td>"
			              + "<td style=\"width:150px;\">" + writer + "</td>"
			              + "<td style=\"width:100px;\">" + vol + "</td>"
			              + "<td style=\"width:150px;\">" + release + "</td>"
			              + "<td style=\"width:150px;\"><img src=\"/Book2/upload/"+pict+"\" width=\"75px\" height=\"75px\"></td>"
			              +"</tr>";
		    }
		}
	} catch (SQLException e) {
		e.printStackTrace();
	}

	tableHTML += "</table>";

	// データベースへのコネクションを閉じる
	db.close();

%>
<!DOCTYPE html>
<html >
	<head>
		<title>MyBookshelf</title>
		<meta charset="UTF-8">
		<link rel="stylesheet"  href="${pageContext.request.contextPath}/book_search.css">
		<link href="https://fonts.googleapis.com/css?family=Caveat rel="stylesheet">
        <script>
			//-------検索-------------------------------------------
    		function fnc_submit(form) {
    			alert("検索");
    			form.submit();
    		}

			//-------検索リセット-------------------------------------------
    		function resetText(form) {
    			alert("リセット");
    			var textForm1 = document.getElementById("book_id");
    			var textForm2 = document.getElementById("book_name");
    		 	textForm1.value = '';
    		 	textForm2.value = '';
    		 	form.submit();
    		}

/*     		//-------前へ-------------------------------------------
    		function back(form){
    			alert("page back");
				//ラジオボタンオブジェクトを取得する
				var radios = document.getElementsByName("td1");
				var result;
			    result = radios[0].value;
			    alert("1つ目の項目は" + result + "です");
			    book_list.first.value = result;

			    form.action = "PageBackClass";
			    form.submit();
    		}

    		//-------次へ-------------------------------------------
    		function next(form){
    			alert("page next");
				//ラジオボタンオブジェクトを取得する
				var radios = document.getElementsByName("td1");
				var result;
			    result = radios[0].value;
			    alert("1つ目の項目は" + result + "です");
			    book_list.first.value = result;

			    form.action = "PageNextClass";
			    form.submit();
    		}
 */
			//-------更新-------------------------------------------
 			function getRadioValue(form){
 				var flag=false;
				//ラジオボタンオブジェクトを取得する
				var radios = document.getElementsByName("td1");

				//取得したラジオボタンオブジェクトから選択されたものを探し出す
				var result;
				for(var i=0; i<radios.length; i++){
				  if (radios[i].checked) {
					  flag=true;
				    //選択されたラジオボタンのvalue値を取得する
				    result = radios[i].value;
				    alert("選択項目は" + result + "です");
				    break;
				  }
				}
				if(!flag){
					alert("項目が選択されていません");
					return;
				}

				form.action = "UpdateBookClass";
				form.submit();
 			}

			//-------削除-------------------------------------------
 			function fnc2_submit(form){
 				var flag=false;
				//ラジオボタンオブジェクトを取得する
				var radios = document.getElementsByName("td1");
				//取得したラジオボタンオブジェクトから選択されたものを探し出す
				var result;
				for(var i=0; i<radios.length; i++){
					  if (radios[i].checked) {
						  flag=true;
					    //選択されたラジオボタンのvalue値を取得する
					    result = radios[i].value;
					    alert("選択項目は" + result + "です");
					    break;
					  }
					}
					if(!flag){
						alert("項目が選択されていません");
						return;
					}

				 var res = confirm("本当に削除しても良いですか？");
				 if( res == true ) {
					 alert("書籍ID"+result+"を削除しました");
					 form.action = "DeleteBookClass";
					 form.submit();
				 }else{
					 alert("削除をキャンセルしました");
				 }

    		 }

			//-------csv出力-------------------------------------------
 			function fnc3_submit(form){
				alert("一覧データをcsvで出力しました");
				form.action = "GenerateCsv";
				form.submit();
 			}

        </script>
	</head>
	<body>
		<header>
			<div style=text-align:right><strong>こんにちは <%=namae %>さん</strong></div>
			<div style=text-align:right><strong>前回ログイン：<%=login %></strong></div>
			<div style=text-align:right>
			<a href="Book_login.jsp">
				<input type="button" id="logout" value="Logout">
			</a>
			</div>
			<h1>Book Search</h1>
			<hr>
		</header>
	<!-- 検索フォーム -->
		<form name="formname" action="SearchBookClass" method="post" >
			<dl>
				<dt><strong>BookID</strong></dt>
				<dd><input type="text" id="book_id" name="book_id" value="<%=book_id %>" autofocus></dd>
				<dt><strong>BookTitle</strong></dt>
				<dd><input type="text" id="book_name" name="book_name" value="<%=book_name%>"></dd>
			</dl>
			<input type="button" id="loginbutton" value="search" onClick="fnc_submit(this.form)">
			<input type="button" id="resetbutton" value="reset" onClick="resetText(this.form)">
		</form>
	<!-- 一覧フォーム -->
		<form  name="book_list" action="PagingClass" method="post">
			<table border="1" class="t-line"  style="border-color:#f5f5f5">
			<tr>
				<th style="width:50px;">check</th>
				<th style="width:50px;">BookID</th>
				<th style="width:250px;">BookTitle</th>
				<th style="width:150px;">writer</th>
				<th style="width:100px;">get vol</th>
				<th style="width:150px;">Last release</th>
				<th style="width:150px;">pic</th>
			</tr>
			<%=tableHTML%>
			</table>
			<!--</div>  -->

			<!-- 20210601_ページング途中 -->
			<ul class="example">

				<%=paging %>

			</ul>
			<input type="hidden" name="first" value="">

		<footer>
				<input type="button" id="entrybutton" value="New entry" onClick="location. href='Book_entry.jsp'">
				<input type="button" id="updatebutton" value="update" onClick="getRadioValue(this.form)">
				<input type="button" id="deletebutton" value="delete" onClick="fnc2_submit(this.form)">
				<input type="button" id="csvbutton" value="csv Download" onClick="fnc3_submit(this.form)">
		</footer>
		</form>

	</body>
</html>
