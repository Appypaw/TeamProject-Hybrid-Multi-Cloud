<!DOCTYPE html>
<html>
<head>
    <title>Fourdollar 벤치마크 입력</title>
    <style>
        /* Reset CSS */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        /* Body Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            text-align: center;
        }

        h1 {
            margin-bottom: 20px;
        }

        form {
            text-align: left;
        }

        label {
            display: inline-block;
            width: 120px;
            margin-bottom: 10px;
        }

        input[type=text],
        input[type=number] {
            width: 200px;
        }

        input[type=submit] {
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>데이터 입력</h1>
        <form action="insert.php" method="post">
            <label for="type">Type:</label>
            <input type="text" name="type" id="type" required><br>

            <label for="part_number">Part Number:</label>
            <input type="text" name="part_number" id="part_number" maxlength="16" required><br>

            <label for="brand">Brand:</label>
            <input type="text" name="brand" id="brand" maxlength="5" required><br>

            <label for="model">Model:</label>
            <input type="text" name="model" id="model" maxlength="36" required><br>

            <label for="rank">Rank:</label>
            <input type="number" name="rank" id="rank" required><br>

            <label for="benchmark">Benchmark:</label>
            <input type="number" step="0.1" name="benchmark" id="benchmark" required><br>

            <label for="samples">Samples:</label>
            <input type="number" name="samples" id="samples" required><br>

            <input type="submit" value="입력 완료">
        </form>
    </div>
</body>
</html>
