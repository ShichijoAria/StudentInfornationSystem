package Controller;

import entity.UserEntity;
import service.impl.UserService;
import util.BaseServlet;
import util.Page;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Created by Ace on 2017/5/24.
 */
public class UserController extends BaseServlet{

    private void view(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String curPage=req.getParameter("curPage");
        UserService userService=new UserService(new UserEntity());
        List<UserEntity> list=userService.getList();
        Page page=new Page();
        initialize(page,list.size(),userService,curPage);
        req.setAttribute("page",page);
        req.setAttribute("list",list);
        req.getRequestDispatcher("/view/user.jsp").forward(req, resp);
    }
}
