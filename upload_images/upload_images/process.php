<?php

// upload file assets
$name = $_FILES['image']['name'];
$type = $_FILES['image']['type'];
$path = $_FILES['image']['tmp_name'];
$err  = $_FILES['image']['error'];
$size = $_FILES['image']['size'];

$description = $_POST['description'];

if ($err == UPLOAD_ERR_OK) {
    echo "UPLOAD COMPLETE: $name,\ntype: $type, size: $size\nPATH: %path\n";
    if (!file_exists("uploads")) {
        mkdir("uploads");
    }

    if (move_uploaded_file($path, "images/$name")) {
        echo "Uploaded file moved\n";
        $files = scandir("images");
        foreach($files as $file) {
            echo "  FILE: $file";
        }
    } else {
        echo "Failed to move file.\n";
    }
} else {
    echo "Error uploading image\n";
}

?>