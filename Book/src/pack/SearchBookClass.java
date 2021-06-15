package pack;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SearchBookClass")
public class SearchBookClass extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public SearchBookClass() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF8");

		String book_id = request.getParameter("book_id");
		String book_name = request.getParameter("book_name");

		request.setAttribute("fromServlet", "select * from t_book order by book_id");

		// 呼び出し先Jspに渡すデータセット
		if(!(isNullOrEmpty(book_id)&&isNullOrEmpty(book_name))) {
			request.setAttribute("fromServlet", "select * from t_book where cast(book_id as text) like'%"
													+book_id+"%' or book_name like '%"+ book_name+"%'order by book_id offset 0 limit 5");
		}

		if(isNullOrEmpty(book_id)&&!(isNullOrEmpty(book_name))) {
			request.setAttribute("fromServlet", "select * from t_book where book_name like '%"
													+book_name+"%'order by book_id offset 0 limit 5");
		}

		if(isNullOrEmpty(book_name)&&!(isNullOrEmpty(book_id))){
			request.setAttribute("fromServlet", "select * from t_book where cast(book_id as text) like'%"
													+book_id+"%'order by book_id offset 0 limit 5");
		}

		//book_idとbook_nameを送る
		request.setAttribute("book_id", book_id );
		request.setAttribute("book_name", book_name );

		//ServletContextに値を保管する
		ServletContext context = this.getServletContext();

		//RequestDispatcherオブジェクトは、画面の遷移先を定義する
		RequestDispatcher dispatcher = context.getRequestDispatcher("/Book_search.jsp");

		//遷移先に転送
		dispatcher.forward(request, response);

	}

	public static boolean isNullOrEmpty(String str) {
		// strがnullもしくは空文字であればtrueを返す
		return (str == null || str.length() == 0);
	}

}
