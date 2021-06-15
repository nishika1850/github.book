package pack;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/PagingClass")
public class PagingClass extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public PagingClass() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF8");

		//ページ数受け取り
		int pages = Integer.parseInt(request.getParameter("page1"));

		//select文
		String moji="select * from t_book where book_id < 51 order by book_id ";
		//offset limit 準備 (1ページ目：offset 1 limit 5)
		String selection_page="offset 0 limit 5";
		int j=5;
		for(int i=0;i<pages-1;i++) {
			selection_page="offset "+(0+j)+" limit 5";
			j+=5;
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
