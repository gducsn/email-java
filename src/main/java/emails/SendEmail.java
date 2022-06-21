package emails;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/sent")
public class SendEmail extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private String user;
	private String pass;

	public void init() {
		// reads SMTP server setting from web.xml file

		ServletContext context = getServletContext();
		user = context.getInitParameter("username");
		pass = context.getInitParameter("password");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String recipient = request.getParameter("recipient");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");

		String message = "";

		try {
			CreateEmail.sendEmail(user, pass, recipient, subject, content);
			message = "The e-mail was sent successfully";
		} catch (Exception ex) {
			ex.printStackTrace();
			message = "There were an error: " + ex.getMessage();
		} finally {
			request.setAttribute("Message", message);
			getServletContext().getRequestDispatcher("/ResultPage.jsp").forward(request, response);
		}
	}
}