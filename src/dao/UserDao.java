package dao;

import entity.UserEntity;
import entity.VisitedEntity;
import util.BaseDao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Ace on 2017/5/19.
 */
public class UserDao extends BaseDao{
    public UserEntity login(UserEntity u){
        String sql="";
        String type=u.getType();
        if(u.getType()!=null) {
            if (u.getType().equals("1")) {//管理员登录
                sql = "SELECT id,name,password FROM t_administrator where id=? and password=?";
            } else if (u.getType().equals("2")) {//教师登录
                sql = "SELECT id,name,password FROM t_teacher where id=? and password=?";
            } else {//学生登录
                sql = "SELECT id,name,password FROM t_student where id=? and password=?";
            }
            ResultSet rs = this.executeQuery(sql, u.getId(), u.getPassword());
            try {
                if (rs.next()) {
                    return new UserEntity(rs.getLong(1), type, rs.getString(2), rs.getString(3));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }

    public List<UserEntity> getList(UserEntity search){
        String t="";
        String sql1="SELECT id,'学生' AS type,name,password FROM t_student ";
        String sql2="SELECT id,'教师' AS type,name,password FROM t_teacher ";
        String sql3="SELECT id,'管理员' AS type,name,password FROM t_administrator ";
        String sql= sql1 + "UNION " + sql2 + "UNION " + sql3;
        if(search!=null) {
            t += " id like '%";
            t += search.getId() <0 ? "" : search.getId();
            t += "%' and name like '%";
            t += search.getName() == null ? "" : search.getName();
            t += "%' ";
            sql1 += "where" + t;
            sql2 += "where " + t;
            sql3 += "where " + t;
            sql= sql1 + "UNION " + sql2 + "UNION " + sql3;
            if(search.getType()!=null) {
                if (search.getType().equals("3")) {
                    sql = sql1;
                } else if (search.getType().equals("2")) {
                    sql = sql2;
                } else if (search.getType().equals("1")) {
                    sql = sql3;
                }
            }
        }
        List<UserEntity> list = new ArrayList<UserEntity>();
        ResultSet rs= this.executeQuery(sql);
        try {
            while(rs.next()){
                list.add(new UserEntity(rs.getLong(1),rs.getString(2),rs.getString(3),rs.getString(4)));
            }
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }finally{
            this.close();
        }
        return list;
    }

    public UserEntity getById(String id){
        String sql="SELECT id,'3' AS type,name,password FROM t_student where id=?" +
                "UNION SELECT id,'2' AS type,name,password FROM t_teacher where id=?" +
                "UNION SELECT id,'1' AS type,name,password FROM t_administrator where id=?";
        ResultSet rs = this.executeQuery(sql, id,id,id);
        try {
            if(rs.next()){
                return new UserEntity(rs.getLong(1),rs.getString(2),rs.getString(3),rs.getString(4));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally{
            this.close();
        }
        return null;
    }

    public int update(UserEntity u,String id){
        String sql="";
        if(u.getType().equals("1")) {
            sql = "update t_administrator set password=? where id=?";
        }else if(u.getType().equals("2")) {
            sql = "update t_teacher set password=? where id=?";
        }else{
            sql = "update t_student set password=? where id=?";
        }
        return this.executeUpdate(sql, u.getPassword(),id);
    }

    public void visitedCount(){
        this.execute("CALL statistical()");
        this.close();
    }

    public long countAll(){
        String sql="SELECT SUM(visited)FROM t_statistical";
        return this.getLong(sql);
    }

    public List<Integer> statistical(){
        String sql="SELECT (SELECT COUNT(*) FROM t_student)," +
                "(SELECT COUNT(*) FROM t_teachingclass)," +
                "(SELECT COUNT(*) FROM t_course)," +
                "(SELECT COUNT(*) FROM t_teacher)";
        List<Integer> list = new ArrayList<Integer>();
        ResultSet rs= this.executeQuery(sql);
        try {
            if(rs.next()){
                for (int i = 0; i < 4; i++) {
                    list.add(rs.getInt(i+1));
                }}
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }finally{
            this.close();
        }
        return list;
    }

    public List<VisitedEntity> count(){
        String sql="SELECT *FROM t_statistical ORDER BY i_date";
        List<VisitedEntity> list = new ArrayList<VisitedEntity>();
        ResultSet rs= this.executeQuery(sql);
        try {
            while(rs.next()){
                list.add(new VisitedEntity(rs.getLong(1),rs.getDate(2)));
            }
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }finally{
            this.close();
        }
        return list;
    }
}
