<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%--
    KinexStore — Welcome File
    Redirige la raíz del contexto al Home de Spring MVC.
--%>
<% response.sendRedirect(request.getContextPath() + "/"); %>
