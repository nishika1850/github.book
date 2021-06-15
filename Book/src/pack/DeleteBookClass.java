package pack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteBookClass")
public class DeleteBookClass extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public DeleteBookClass() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF8");

		String bookid = request.getParameter("td1");

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

		try {
			conn = DriverManager.getConnection(url, user, password);
		} catch (SQLException e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}

		Statement stmt =null;

		try {
			stmt = conn.createStatement();

			String sql ="delete from t_book where book_id=" + bookid;
			stmt.executeUpdate(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null) {
					stmt.close();
					conn.close();
				}
			} catch (SQLException e) {
				throw new ServletException();
			}
		}


		//ServletContextに値を保管する
		ServletContext context = this.getServletContext();

		//RequestDispatcherオブジェクトは、画面の遷移先を定義する
		RequestDispatcher dispatcher = context.getRequestDispatcher("/Book_search.jsp");

		//遷移先に転送
		dispatcher.forward(request, response);
	}

}
