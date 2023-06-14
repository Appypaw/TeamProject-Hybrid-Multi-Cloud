<?php
// 데이터베이스 연결 및 쿼리 작성
$servername = "";
$username = "";
$password = "";
$dbname = "";

// 데이터베이스 연결 및 오류 처리
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// POST 데이터 가져오기
$type = $_POST['type'];
$part_number = $_POST['part_number'];
$brand = $_POST['brand'];
$model = $_POST['model'];
$rank = $_POST['rank'];
$benchmark = $_POST['benchmark'];
$samples = $_POST['samples'];

// 쿼리 작성
$sql = "INSERT INTO benchmark (`Type`, Part_Number, Brand, Model, Ranking, Benchmarks, Samples) 
        VALUES ('$type', '$part_number', '$brand', '$model', $rank, $benchmark, $samples)";

// 쿼리 실행
if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

// 데이터베이스 연결 종료
$conn->close();
?>
