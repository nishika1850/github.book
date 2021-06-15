package pack;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GenerateCsv")
public class GenerateCsv extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public GenerateCsv() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF8");
    	String sql = "SELECT * FROM t_book order by book_id";

		//ドライバ
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}

		//接続文字列
		String url = "jdbc:postgresql://localhost/postgres";
		String user = "postgres";
		String password = "postgres";

		//PostgreSQLへ接続
		Connection conn = null;
		Statement stmt = null;

		try {
			conn = DriverManager.getConnection(url, user, password);
		} catch (SQLException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}

		try {
			stmt = conn.createStatement();
		} catch (SQLException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}


		ResultSet rs=null;
		try {
			rs = stmt.executeQuery(sql);
		} catch (SQLException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}

    	BufferedWriter bw=new BufferedWriter(new OutputStreamWriter(new FileOutputStream("MyBookshelfdate.csv", true),"Shift-JIS"));
    	//BufferedWriter bw=new BufferedWriter(new OutputStreamWriter(new FileOutputStream("C:\\Users\\kensyu\\Desktop\\MyBookshelfdate.csv", true),"Shift-JIS"));

    	bw.write("書籍ID,タイトル,筆者,所持巻数,最終発売日");
    	bw.newLine();

    	try {
			while(rs.next()){
				bw.write(rs.getString(1));bw.write(",");
				bw.write(rs.getString(2));bw.write(",");
				bw.write(rs.getString(3));bw.write(",");
				bw.write(rs.getString(4));bw.write(",");
				bw.write(rs.getString(5));bw.newLine();
			}
		} catch (SQLException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();

		}

    	bw.close();

		//ServletContextに値を保管する
		ServletContext context = this.getServletContext();

		//RequestDispatcherオブジェクトは、画面の遷移先を定義する
		RequestDispatcher dispatcher = context.getRequestDispatcher("/Book_search.jsp");

		//遷移先に転送
		dispatcher.forward(request, response);

    }
}