<?php
try {
    $pdo = new PDO("mysql:host=localhost", "root", "");
    echo "Connected";
} catch (Exception $e) {
    echo $e->getMessage();
}
