<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
	
	<link rel="icon" type="image/x-icon" href="https://img.icons8.com/ios/344/circled-envelope.png">
	
<title>Send an e-mail</title>
</head>
<body>
	<div class="d-flex justify-content-center align-items-center p-5">

		<form action="sent" method="post" class="form-group">
			<div class="form-group">
				<label for="exampleInputEmail1">Email address</label> <input placeholder="Address to send to" required
					name="recipient" type="email" class="form-control"
					id="exampleInputEmail1">
			</div>
			<div class="form-group">
				<label for="exampleInputPassword1">Subject</label> <input placeholder="Subject"
					name="subject" type="text" class="form-control"
					id="exampleInputPassword1">
			</div>
			<div class="form-group">
				<textarea rows="8" cols="39" name="content" name="content" placeholder="Content"></textarea>
			</div>
			<button type="submit" class="btn btn-primary btn-dark w-100">Submit</button>
		</form>





	</div>
</body>
</html>