package pack;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/DataUpdateClass")
@MultipartConfig
public class DataUpdateClass extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public DataUpdateClass() {
        super();

    }

//検索画面へ更新データの受け渡し
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 呼び出し元Jspからデータ受け取り
		request.setCharacterEncoding("UTF8");

		String bookid = request.getParameter("bookid");
		String bookname = request.getParameter("bookname");
		String bookwriter = request.getParameter("bookwriter");
		String bookvol = request.getParameter("bookvol");
		String bookrelease = request.getParameter("bookreleasedate");

		//name属性がpictのファイルをPartオブジェクトとして取得
		Part part=request.getPart("pict");
		//ファイル名を取得
		//String filename=part.getSubmittedFileName();//ie対応が不要な場合
		String filename=Paths.get(part.getSubmittedFileName()).getFileName().toString();

		//filenameが""じゃなかったら
		if(!(isNullOrEmpty(filename))) {
			//アップロードするフォルダ
			String path=getServletContext().getRealPath("/upload");
			//実際にファイルが保存されるパス確認
			//System.out.println(path);
			//書き込み
			part.write(path+File.separator+filename);
			//実際にファイルが保存されるパス確認
			//System.out.println(path);

			request.setAttribute("filename", filename);
		}

		//booknameは必須入力（それ以外は任意）
		//筆者nullなら未入力が入る
		if(isNullOrEmpty(bookwriter)){
			bookwriter = "未入力";
		}

		//巻数nullなら1が入る
		if(isNullOrEmpty(bookvol)){
			bookvol ="1";
		}

		//発売日nullなら2021/01/01が入る
		if(isNullOrEmpty(bookrelease)){
			bookrelease = "2021/01/01";
		}


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
			String sql="";

			//pictがnullなら
			if(isNullOrEmpty(filename)){
				sql ="update t_book set book_name='"+bookname+"', book_writer='"+bookwriter+"',book_vol="+bookvol+","
						+ "book_release_date='"+bookrelease+"'where book_id="+bookid;
				}else {
					sql ="update t_book set book_name='"+bookname+"', book_writer='"+bookwriter+"',book_vol="+bookvol+","
							+ "book_release_date='"+bookrelease+"',pict='"+filename+"' where book_id="+bookid;
			}
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

		ServletContext context = this.getServletContext();
		//RequestDispatcherオブジェクトは、画面の遷移先を定義する
		RequestDispatcher dispatcher = context.getRequestDispatcher("/Book_search.jsp");
		//遷移先に転送
		dispatcher.forward(request, response);
		//doGet(request, response);
	}

	public static boolean isNullOrEmpty(String str) {
		// strがnullもしくは空文字であればtrueを返す
		return (str == null || str.length() == 0);
	}


}