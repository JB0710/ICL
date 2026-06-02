<?php
require_once 'includes/db.php';

$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $fill_date = $_POST['fill_date'] ?? '';
    $odometer = $_POST['odometer'] ?? '';
    $gallons = $_POST['gallons'] ?? '';
    $price = $_POST['price'] ?? '';

    if ($fill_date && $odometer && $gallons && $price) {
        $total_cost = $gallons * $price;

        try {
            $sql = "INSERT INTO fuel_entries (fill_date, odometer, gallons, price_per_gallon, total_cost) VALUES (?, ?, ?, ?, ?)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute([$fill_date, $odometer, $gallons, $price, $total_cost]);
            header("Location: index.php");
            die();
        } catch (\PDOException $e) {
            $message = "Error: " . $e->getMessage();
        }
    } else {
        $message = "Please fill in all fields.";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Fuel Entry</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Fuel Tracker</h1>
            <nav>
                <a href="index.php">Dashboard</a>
                <a href="add.php" class="active">Add Entry</a>
            </nav>
        </header>

        <section class="form-container">
            <h2>Add New Fueling</h2>
            <?php if ($message): ?>
                <div class="alert"><?php echo htmlspecialchars($message); ?></div>
            <?php endif; ?>
            <form action="add.php" method="POST">
                <div class="form-group">
                    <label for="fill_date">Date</label>
                    <input type="date" name="fill_date" id="fill_date" value="<?php echo date('Y-m-d'); ?>" required>
                </div>
                <div class="form-group">
                    <label for="odometer">Odometer Reading (mi)</label>
                    <input type="number" step="0.1" name="odometer" id="odometer" placeholder="e.g. 12500.5" required>
                </div>
                <div class="form-group">
                    <label for="gallons">Gallons</label>
                    <input type="number" step="0.01" name="gallons" id="gallons" placeholder="e.g. 12.50" required>
                </div>
                <div class="form-group">
                    <label for="price">Price per Gallon</label>
                    <input type="number" step="0.001" name="price" id="price" placeholder="e.g. 3.459" required>
                </div>
                <button type="submit" class="btn">Save Entry</button>
            </form>
        </section>
    </div>
</body>
</html>
