package pack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.LoginDataBean;

@WebServlet("/LoginSearchClass")

public class LoginSearchClass extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LoginSearchClass() {
		super();
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		//20210524メモ※あとでDBAccessに書き換える
		// 呼び出し元Jspからデータ受け取り
		request.setCharacterEncoding("UTF8");

		String userid = request.getParameter("userid");
		String userpass = request.getParameter("userpass");

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

		List<LoginDataBean> list = new ArrayList<LoginDataBean>();
		ResultSet rset = null;

		try {

			String sql = "select user_id,user_pass from t_book_login";
			sql = sql + " WHERE user_id = '" + userid + "'";
			sql = sql + "   AND user_pass = '" + userpass + "'";

			rset = stmt.executeQuery(sql);


			//ID・パスワードデータベースと照らし合わせ
			while (rset.next()) {

				list.add(new LoginDataBean(rset.getString("user_id"), rset.getString("user_pass")));

			}
			rset.close();

		} catch (Exception e) {
			//検索処理で異常終了
			e.printStackTrace();

		} /*finally {
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}

			}*/

		if (list == null || list.size() == 0) {
			//認証不可
			//画面にメッセージを返却する
			request.setAttribute("message", "Login error：user IDかpasswordに誤りがあります");

			//RequestDispatcherオブジェクトは、画面の遷移先を定義する
			ServletContext context = this.getServletContext();
			RequestDispatcher dispatcher = context.getRequestDispatcher("/Book_login.jsp");

			//遷移先に転送
			dispatcher.forward(request, response);

		} else {

			//認証成功
			//usernameを送る
		    String namae="select user_name from t_book_login where user_id='"+userid+"'and user_pass='"+userpass+"'";
	 		ResultSet rs = null;
	 		try {
				rs=stmt.executeQuery(namae);
			} catch (SQLException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}

			try {
				while(rs.next()) {
					namae=rs.getString("user_name");
					}
			} catch (SQLException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}


			//lastlogin時間を送る
			String lastlogin="select last_login from t_book_login where user_id='"+userid+"'and user_pass='"+userpass+"'";
			ResultSet rs1 = null;
			try {
				rs1=stmt.executeQuery(lastlogin);
			} catch (SQLException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}

			try {
				while(rs1.next()) {
					lastlogin=rs1.getString("last_login");
					}
			} catch (SQLException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}

			//セッション設定
		    HttpSession session = request.getSession();
			session.setAttribute("username",namae);
			session.setAttribute("lastlogin",lastlogin);

			//lastlogin日更新
			String sql ="update t_book_login set last_login=CURRENT_DATE where user_id='"+userid+"'";
			try {
				stmt.executeUpdate(sql);
			} catch (SQLException e) {
				// TODO 自動生成された catch ブロック
				e.printStackTrace();
			}

			//ServletContextに値を保管する
			ServletContext context = this.getServletContext();

			//RequestDispatcherオブジェクトは、画面の遷移先を定義する
			RequestDispatcher dispatcher = context.getRequestDispatcher("/Book_search.jsp");

			//遷移先に転送
			dispatcher.forward(request, response);

		}

	}
}
