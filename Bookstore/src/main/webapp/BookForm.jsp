<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="https://java.sun.com/jsp/jstl/core" prefix="c"%>
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
		        
		<c:if test="${book != null}">
            <form action="update" method="post">        
		</c:if>
		        
		<c:if test="${book == null}">
            <form action="insert" method="post">        
		</c:if>
		        
		<table border="1" cellpadding="5">
			<caption>                                     
				<c:if test="${book != null}">
                        Edit Book
                </c:if>
				<c:if test="${book == null}">
                        Add New Book
                </c:if>                             
			</caption>
				<c:if test="${book != null}">
                    <input type="hidden" name="id" value="<c:out value='${book.id}' />" />
                </c:if>
			<tr>
				<th>Title:</th>
				<td> 
				<input type="text" name="title" size="45" value="<c:out value='${book.title}' />" />				                
				</td>
			</tr>
			<tr>
				<th>Author:</th>
				<td> 
				<input type="text" name="author" size="45" value="<c:out value='${book.author}' />" />         
				</td>
			</tr>
			<tr>
				<th>Price:</th>
				<td> 
				<input type="text" name="price" size="5" value="<c:out value='${book.price}' />" />    
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				<input type="submit" value="Save" />                 
				</td>
			</tr>
		</table>
		        
		</form>
		    
	</div>
</body>
</html>