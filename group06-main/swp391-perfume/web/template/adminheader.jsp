<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Header</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                margin: 0;
                padding: 0;
                display: flex;
            }

            /* Sidebar layout, s?a l?i chi?u r?ng nh? g?n */
            .navbar {
                width: 200px; /* Gi?m chi?u r?ng c?a sidebar */
                min-height: 100vh;
                background-color: #343a40;
                position: fixed;
                top: 0;
                left: 0;
                padding-top: 20px;
                color: white;
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }

            .navbar-brand {
                padding-left: 15px;
                font-size: 22px;
                font-weight: bold;
                color: white;
            }

            .navbar-nav {
                display: flex;
                flex-direction: column;
                width: 100%;
                margin-top: 20px;
            }

            .navbar-nav .nav-link {
                padding: 10px 15px; /* Gi?m padding cho g?n g஧ */
                font-size: 16px;
                color: white;
                display: flex;
                align-items: center;
            }

            .navbar-nav .nav-link i {
                margin-right: 10px;
            }

            .navbar-nav .nav-link:hover {
                background-color: #495057;
            }

            /* Dropdown hover styling */
            .nav-item.dropdown:hover .dropdown-menu {
                display: block;
            }

            .dropdown-menu {
                background-color: #343a40;
                border: none;
                display: none;
                position: absolute;
            }

            .dropdown-item {
                color: white;
            }

            .dropdown-item:hover {
                background-color: #495057;
            }

        </style>
    </head>
    <body>
        <!-- Sidebar Navbar -->
        <nav class="navbar navbar-expand-lg bg-dark flex-column">
            <a class="navbar-brand" href="admin"><i class="fas fa-store"></i> Home</a>
            <div class="navbar-collapse">
                <ul class="navbar-nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="admin"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="Salesvieworder"><i class="fas fa-shopping-cart"></i> Orders</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button">
                            <i class="fas fa-boxes"></i> Manage product
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="addperfume">Add perfume</a></li>
                            <li><a class="dropdown-item" href="addbrand">Add brand</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="SalesLogout"><i class="fas fa-sign-out-alt"></i> Log out</a>
                    </li>
                </ul>
            </div>
        </nav>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
