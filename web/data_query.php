<!DOCTYPE html>
<html>
<head>
    <title>Fourdollar 벤치마크 조회</title>
    <style>
        /* CSS 스타일링 */
        /* ... */

    </style>
</head>
<body>
    <div class="container">
        <h1>데이터 조회 페이지</h1>
        <table>
            <tr>
                <th>타입</th>
                <th>부품 번호</th>
                <th>브랜드</th>
                <th>모델</th>
                <th>순위</th>
                <th>벤치마크</th>
                <th>샘플 수</th>
            </tr>

            <?php
            // 데이터베이스 연결 정보
            $servername = "";
            $username = "";
            $password = "";
            $dbname = "";

            // 페이지당 표시할 데이터 개수
            $perPage = 10;

            // 현재 페이지 번호 (GET 또는 POST로 전달받음)
            $currentPage = $_GET['page'] ?? 1;

            // 데이터베이스 연결
            $conn = new mysqli($servername, $username, $password, $dbname);

            // 연결 오류 확인
            if ($conn->connect_error) {
                die("Connection failed: " . $conn->connect_error);
            }

            // 총 데이터 개수 조회 쿼리
            $totalCountQuery = "SELECT COUNT(*) as total FROM benchmark";
            $totalCountResult = $conn->query($totalCountQuery);
            $totalCountRow = $totalCountResult->fetch_assoc();
            $totalCount = $totalCountRow['total'];

            // 총 페이지 수 계산
            $totalPages = ceil($totalCount / $perPage);

            // 시작 위치(offset) 계산
            $offset = ($currentPage - 1) * $perPage;

            // 데이터 조회 쿼리 (페이징 적용)
            $query = "SELECT `Type`, Part_Number, Brand, Model, Ranking, Benchmarks, Samples FROM benchmark LIMIT $offset, $perPage";
            $result = $conn->query($query);

            if ($result->num_rows > 0) {
                // 결과를 반복하여 출력
                while ($row = $result->fetch_assoc()) {
                    echo "<tr>";
                    echo "<td>".$row['Type']."</td>";
                    echo "<td>".$row['Part_Number']."</td>";
                    echo "<td>".$row['Brand']."</td>";
                    echo "<td>".$row['Model']."</td>";
                    echo "<td>".$row['Ranking']."</td>";
                    echo "<td>".$row['Benchmarks']."</td>";
                    echo "<td>".$row['Samples']."</td>";
                    echo "</tr>";
                }
            } else {
                echo "<tr><td colspan='7'>No data found</td></tr>";
            }

            // 데이터베이스 연결 종료
            $conn->close();
            ?>
        </table>

        <!-- 페이징 링크 생성 -->
        <div class="pagination">
            <?php
            // 이전 페이지 링크
            if ($currentPage > 1) {
                echo "<a href='?page=".($currentPage - 1)."'>이전</a>";
            }

            // 페이지 번호 링크
            for ($i = 1; $i <= $totalPages; $i++) {
                echo "<a href='?page=".$i."'>".$i."</a>";
            }

            // 다음 페이지 링크
            if ($currentPage < $totalPages) {
                echo "<a href='?page=".($currentPage + 1)."'>다음</a>";
            }
            ?>
        </div>
    </div>
</body>
</html>