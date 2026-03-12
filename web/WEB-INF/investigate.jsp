<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Alert" %>

<%
    Alert alert = (Alert) request.getAttribute("alert");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Investigate Alert</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light p-5">

        <div class="container max-w-75">
            <h2 class="mb-4 text-primary">Investigate Alert</h2>

            <div class="card shadow-sm border-0 p-4">
                
                <div class="row mb-3">
                    <div class="col-sm-3 text-secondary">Alert ID:</div>
                    <div class="col-sm-9 fw-bold"><%=alert.getAlertId()%></div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-3 text-secondary">Entity Type:</div>
                    <div class="col-sm-9"><%=alert.getEntityType()%></div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-3 text-secondary">Entity ID:</div>
                    <div class="col-sm-9"><%=alert.getEntityId()%></div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-3 text-secondary">Risk Score:</div>
                    <div class="col-sm-9 text-danger fw-bold"><%=alert.getRiskScore()%></div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-3 text-secondary">Status:</div>
                    <div class="col-sm-9"><span class="badge bg-warning text-dark"><%=alert.getStatus()%></span></div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-3 text-secondary">Reason:</div>
                    <div class="col-sm-9"><%=alert.getMessage()%></div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-3 text-secondary">Created At:</div>
                    <div class="col-sm-9"><%=alert.getCreatedAt()%></div>
                </div>

                <hr class="my-4">

                <div class="d-flex justify-content-between align-items-center">
                    
                    <a href="<%=request.getContextPath()%>/AlertController" class="btn btn-outline-secondary px-4">
                        Back
                    </a>

                    <div class="d-flex gap-3">
                        <form action="<%=request.getContextPath()%>/AlertController" method="post" class="m-0">
                            <input type="hidden" name="action" value="reject">
                            <input type="hidden" name="alertId" value="<%=alert.getAlertId()%>">
                            <input type="hidden" name="invoiceId" value="<%=alert.getEntityId()%>">
                            <button type="submit" class="btn btn-danger px-4">
                                Reject
                            </button>
                        </form>

                        <form action="<%=request.getContextPath()%>/AlertController" method="post" class="m-0">
                            <input type="hidden" name="action" value="resolve">
                            <input type="hidden" name="alertId" value="<%=alert.getAlertId()%>">
                            <input type="hidden" name="invoiceId" value="<%=alert.getEntityId()%>">
                            <button type="submit" class="btn btn-success px-4">
                                Approve
                            </button>
                        </form>
                    </div>

                </div>

            </div>
        </div>

    </body>
</html>