<html>
	<head>
	<title>Flight Destinations</title>
	</head>	
	<style type="text/css">
		.search img {
			margin: 0px auto;
			display: block;
		}
		.stats {
			margin: 0px auto;
			display: block;
		}
		.search form {
			text-align: center;
		}
		h2, h1 {
			text-align: center;
		}
		table, th, td {
			border: 1px solid black;
			border-collapse: collapse;
		}
	</style>
	<body>
		<div class="search">
		<h1>Customer SignUp Page</h1>
			<img src="img/travel.jpg" alt="logo" style="width:300;height:80px;"/>
			<form method="post">
				<input type="text" name="typeID" placeholder="Customer type..."/>
				<input type="text" name="Fname" placeholder="First Name..."/>
				<input type="text" name="Lname" placeholder="Last Name..."/>
				<input type="text" name="dob" placeholder="yyyy-mm-dd..."/>
 				<input type="submit" name="submit" value="INSERT"/><br/>
			</form>
		</div>
		<?php
			header("Content-Type: text/html; charset=ISO-8859-1");
				
			

			if(isset($_POST['submit'])) {
				try {
				$conn = new PDO("sqlsrv:Server=IS-HAY04.ischool.uw.edu;Database=HAYAK2", "INFO445", "GoHuskies!");
				$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
				if($conn){
					print("Connected to database");
					echo '<br>';
					echo '<br>';
					Print("Last 10 Inserted Customers to the database");
					echo '<br>';
					echo '<br>';
				}
				//$id = $_POST['ID'];
				$ty = $_POST['typeID'];
				$fn = $_POST['Fname'];
				$ln = $_POST['Lname'];
				$dob = $_POST['dob'];
				
				
				
				$sql = $conn->prepare("INSERT INTO CUSTOMER (CustomerTypeID, CustomerFName, CustomerLName, CustomerDOB) VALUES (?, ?, ?, ?)");
				//$sql->bindValue(1, $id);
				$sql->bindValue(1, $ty);
				$sql->bindValue(2, $fn);
				$sql->bindValue(3, $ln);
				$sql->bindValue(4, $dob);
				
				$sql->execute();
				}
				catch (PDOException $e){
					print("error with connection");
					die(print_r($e));
				}
				
				$tsql = "SELECT TOP 10 WITH TIES CustomerID, CustomerTypeID, CustomerFName, CustomerLName, CustomerDOB FROM CUSTOMER ORDER BY CustomerID DESC";
				$getResults = $conn->prepare($tsql);
				$getResults -> execute();
				$results = $getResults->fetchAll(PDO::FETCH_BOTH);

				foreach($results as $row){
					echo $row['CustomerID'].' '.$row['CustomerTypeID'].' '.$row['CustomerFName'].' '.$row['CustomerLName'].' '.$row['CustomerDOB'];
					echo '<br>';
				}
			}
			
			//echo(Stats::displayInfo());
		
		?>
	</body>
</html>