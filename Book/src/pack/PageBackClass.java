package pack;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/PageBackClass")
public class PageBackClass extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public PageBackClass() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 呼び出し元Jspからデータ受け取り
		request.setCharacterEncoding("UTF8");

		//現在のページの1つ目の値を取得
		int first = Integer.parseInt(request.getParameter("first"));

		//select文
		String moji="select * from t_book where book_id < 51 order by book_id ";
		//offset limit 準備 (1ページ目：offset 1 limit 5)
		String selection_page="offset 0 limit 5";
		if(!(first==1)) {
			selection_page="offset"+ (first-6)+" limit 5";
		}

		moji+=selection_page;

		//paging_sessionを送る
		request.setAttribute("paging_session",moji);

		ServletContext context = this.getServletContext();
		//RequestDispatcherオブジェクトは、画面の遷移先を定義する
		RequestDispatcher dispatcher = context.getRequestDispatcher("/Book_search.jsp");
		//遷移先に転送
		dispatcher.forward(request, response);
	}

}
