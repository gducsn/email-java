<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
<link rel="icon" type="image/x-icon" href="https://img.icons8.com/ios/344/circled-envelope.png">
<title>Result</title>
</head>
<body>
<div class="d-flex justify-content-center p-5 align-items-center">
		<h3 class="h-3 lead"><%=request.getAttribute("Message")%></h3>
	</div>
</body>
</html>