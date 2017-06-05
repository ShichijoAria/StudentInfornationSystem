package Controller;

import dao.UserDao;
import entity.UserEntity;
import service.impl.UserService;
import util.BaseServlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by Ace on 2017/5/19.
 */
public class DesktopController extends BaseServlet{

    private void hello(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private void signIn(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login/login.jsp").forward(req, resp);
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserEntity user=new UserService().login(new UserEntity(Long.parseLong(req.getParameter("id")),req.getParameter("type"),req.getParameter("password")));
        if(user!=null) {
            new UserDao().visitedCount();
            req.getSession().setAttribute("userId",user.getId());
            req.getSession().setAttribute("userPassword",user.getPassword());
            req.getSession().setAttribute("userName",user.getName());
            req.getSession().setAttribute("userType",user.getType());
            resp.sendRedirect("/SIS/desktop/hello");
        }else{
            resp.sendRedirect("/SIS/desktop/signIn");
        }
    }

    private void loginOut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().removeAttribute("userId");
        req.getSession().removeAttribute("userPassword");
        req.getSession().removeAttribute("userName");
        req.getSession().removeAttribute("userType");
        resp.sendRedirect("/SIS/desktop/signIn");
    }

    private void welcome(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.setAttribute("countAll",new UserDao().countAll());
        req.setAttribute("list",new UserDao().statistical());
        req.setAttribute("statistical",new UserDao().count());
        req.getRequestDispatcher("/welcome/welcome.jsp").forward(req, resp);
    }

    @Override
    public void init() throws ServletException {

    }

    @Override
    public void destroy() {

    }
}
