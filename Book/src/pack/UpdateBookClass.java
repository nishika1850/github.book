package pack;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MyDBAccess;

@WebServlet("/UpdateBookClass")
public class UpdateBookClass extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UpdateBookClass() {
		super();
	}

//更新画面へ選択したもののデータの受け渡し
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF8");

		String bookid = request.getParameter("td1");

		// MyDBAccess のインスタンスを生成する
		MyDBAccess db = new MyDBAccess();
		/*driver = "org.postgresql.Driver";
		url = "jdbc:postgresql://localhost/postgres";
		user = "postgres";
		password = "postgres";*/

		// データベースへのアクセス
		try {
			db.open();
			/*Class.forName(driver);
			  connection = DriverManager.getConnection(url, user, password);
			  statement = connection.createStatement();*/
		} catch (Exception e) {
			// TODO 自動生成された catch ブロック
			e.printStackTrace();
		}

		//bookidを送る
		request.setAttribute("t_book", "select * from t_book where book_id=" + bookid );

		//ServletContextに値を保管する
		ServletContext context = this.getServletContext();

		//RequestDispatcherオブジェクトは、画面の遷移先を定義する
		RequestDispatcher dispatcher = context.getRequestDispatcher("/Book_update.jsp");

		//遷移先に転送
		dispatcher.forward(request, response);
	}

}
