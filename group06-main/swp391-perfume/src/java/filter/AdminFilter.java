package filter;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Admin;

/**
 *
 * @author DELL
 */
public class AdminFilter implements Filter {

    private static final boolean debug = true;

    private FilterConfig filterConfig = null;

    public AdminFilter() {
    }

    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AdminFilter:DoBeforeProcessing");
        }
    }

    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AdminFilter:DoAfterProcessing");
        }
    }

    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        // Kiểm tra xem admin có đăng nhập không
        if (admin == null) {
            res.sendRedirect("adminlogin");
            return;
        }

        // Lấy đường dẫn hiện tại của request
        String requestURI = req.getRequestURI();

        // Kiểm tra vai trò của admin và chuyển hướng dựa trên role
        switch (admin.getRole()) {
            case 0:  // Role Marketer NHƯNG ĐƯỜ   NG DẪN LÀ ADMIN THÔI ĐỪNG HIỂU LẦM 
                if (!requestURI.contains("admin")) {
                    res.sendRedirect(req.getContextPath() + "/admin");
                    return;
                }
                break;
            case 1:  // Role ADMIN
                if (!requestURI.contains("admindashboard")) {
                    res.sendRedirect(req.getContextPath() + "/admindashboard");
                    return;
                }
                break;
            case 2:  // Role Sale Manager
                if (!requestURI.contains("Sales")) {
                    res.sendRedirect(req.getContextPath() + "/Sales");
                    return;
                }
                break;
            case 3:  // Role Inventory
                if (!requestURI.contains("Inventory")) {
                    res.sendRedirect(req.getContextPath() + "/Inventory");
                    return;
                }
                break;
            case 4:  // Role Inventory
                if (!requestURI.contains("Staff")) {
                    res.sendRedirect(req.getContextPath() + "/Staff");
                    return;
                }
                break;
            default:
                // Nếu không có role nào hợp lệ
                res.sendRedirect(req.getContextPath() + "/errorPage.jsp");
                return;
        }

        // Nếu đã ở đúng trang, tiếp tục chuỗi filter
        chain.doFilter(request, response);
    }

    public FilterConfig getFilterConfig() {
        return this.filterConfig;
    }

    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    public void destroy() {
    }

    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {
                log("AdminFilter:Initializing filter");
            }
        }
    }

    @Override
    public String toString() {
        if (filterConfig == null) {
            return "AdminFilter()";
        }
        StringBuffer sb = new StringBuffer("AdminFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return sb.toString();
    }

    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);

        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n");
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");
                pw.print(stackTrace);
                pw.print("</pre></body>\n</html>");
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        }
    }

    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
        }
        return stackTrace;
    }

    public void log(String msg) {
        filterConfig.getServletContext().log(msg);
    }
}
