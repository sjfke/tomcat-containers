<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Books Store Application</title>
</head>
<body>

	<div align="center">
		        
		<h1>Books Management</h1>
		        
		<h2>
			<c:url value="/new" var="newUrl" />
			<c:url value="/list" var="listUrl" />
			<a href="${newUrl}">Add New Book</a> &nbsp;&nbsp;&nbsp; <a href="${listUrl}">List All Books</a>         
		</h2>
	</div>
	
		<div align="center">
		        
		<table border="1" cellpadding="5">
			<caption>List of Books</caption>
			<tr>
				<th>ID</th>
				<th>Title</th>
				<th>Author</th>
				<th>Price</th>
				<th>Actions</th>
			</tr>
			
			<c:url value="/edit" var="editUrl" />
			<c:url value="/delete" var="deleteUrl" />
			<c:forEach var="book" items="${listBook}">
				<tr>
					<td><c:out value="${book.id}" /></td>
					<td><c:out value="${book.title}" /></td>
					<td><c:out value="${book.author}" /></td>
					<td><c:out value="${book.price}" /></td>
					<td><a href="${editUrl}?id=<c:out value='${book.id}' />">Edit</a>
						&nbsp;&nbsp;&nbsp;&nbsp; <a
						href="${deleteUrl}?id=<c:out value='${book.id}' />">Delete</a>                     
					</td>
				</tr>
			</c:forEach>
		</table>
		    
	</div>
	
</body>
</html>