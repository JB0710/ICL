<?php
require_once 'includes/db.php';

// Fetch all entries sorted by odometer descending (most recent first)
$stmt = $pdo->query("SELECT * FROM fuel_entries ORDER BY odometer DESC, fill_date DESC");
$entries = $stmt->fetchAll();

// Calculate Statistics
$total_distance = 0;
$total_gallons = 0;
$total_cost = 0;
$mpg = 0;
$avg_price = 0;

if (count($entries) > 1) {
    $latest = $entries[0];
    $oldest = $entries[count($entries) - 1];

    $total_distance = $latest['odometer'] - $oldest['odometer'];

    foreach ($entries as $index => $entry) {
        if ($index < count($entries) - 1) { // Skip oldest entry gallons for MPG calc
             $total_gallons += $entry['gallons'];
        }
        $total_cost += $entry['total_cost'];
    }

    if ($total_gallons > 0) {
        $mpg = $total_distance / $total_gallons;
    }

    $all_gallons = array_sum(array_column($entries, 'gallons'));
    if ($all_gallons > 0) {
        $avg_price = $total_cost / $all_gallons;
    }
} elseif (count($entries) == 1) {
    $total_cost = $entries[0]['total_cost'];
    $all_gallons = $entries[0]['gallons'];
    $avg_price = $total_cost / $all_gallons;
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fuel Tracker Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Fuel Tracker</h1>
            <nav>
                <a href="index.php" class="active">Dashboard</a>
                <a href="add.php">Add Entry</a>
            </nav>
        </header>

        <section class="stats">
            <div class="card">
                <h3>Total Distance</h3>
                <p><?php echo number_format($total_distance, 1); ?> mi</p>
            </div>
            <div class="card">
                <h3>Efficiency</h3>
                <p><?php echo number_format($mpg, 2); ?> MPG</p>
            </div>
            <div class="card">
                <h3>Total Cost</h3>
                <p>$<?php echo number_format($total_cost, 2); ?></p>
            </div>
            <div class="card">
                <h3>Avg Price</h3>
                <p>$<?php echo number_format($avg_price, 3); ?> /gal</p>
            </div>
        </section>

        <section class="history">
            <h2>Fueling History</h2>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Odometer (mi)</th>
                        <th>Gallons</th>
                        <th>Price/gal</th>
                        <th>Total Cost</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($entries as $entry): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($entry['fill_date']); ?></td>
                        <td><?php echo number_format($entry['odometer'], 1); ?></td>
                        <td><?php echo number_format($entry['gallons'], 2); ?></td>
                        <td>$<?php echo number_format($entry['price_per_gallon'], 3); ?></td>
                        <td>$<?php echo number_format($entry['total_cost'], 2); ?></td>
                    </tr>
                    <?php endforeach; ?>
                    <?php if (empty($entries)): ?>
                    <tr>
                        <td colspan="5" style="text-align:center;">No entries found. <a href="add.php">Add your first fueling!</a></td>
                    </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </section>
    </div>
</body>
</html>
