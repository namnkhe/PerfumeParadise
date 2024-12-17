<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Stock"%>
<%@ page import="model.Selling"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sales Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .sidebar {
                width: 250px;
                position: fixed;
                top: 0;
                left: 0;
                height: 100%;
                background-color: #343a40;
            }
            .main-content {
                margin-left: 270px; /* Adjusted to account for sidebar width */
                padding: 20px;
            }
            .dashboard-card {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px;
                background-color: #ffffff;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .dashboard-card h5 {
                margin: 0;
            }
            .card canvas {
                width: 100% !important;
                height: 300px !important; /* Ensures the canvas fills the card */
            }
        </style>
    </head>
    <body>

        <!-- Include header/sidebar from adminheader.jsp -->
        <div class="sidebar">
            <jsp:include page="template/adminheader.jsp"/>
        </div>

        <div class="main-content">
            <div class="container my-4">
                <div class="row text-center mb-4">
                    <!-- Dashboard cards for statistics -->
                    <div class="col-md-3 col-sm-6">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">Customers</h5>
                                <p class="card-text display-4 text-primary">${ccount}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">Products</h5>
                                <p class="card-text display-4 text-success">${pcount}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">Complete Orders</h5>
                                <p class="card-text display-4 text-warning">${ocount}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">Total Earning</h5>
                                <p class="card-text display-4 text-danger">${totalprice}$</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <!-- Charts for Stock and Selling data -->
                    <div class="col-lg-6 mb-4">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <canvas id="stock"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 mb-4">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <canvas id="selling"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%
            List<Stock> stocks = (List<Stock>) request.getAttribute("stocks");
            List<Selling> sellings = (List<Selling>) request.getAttribute("sellings");
        %>

        <!-- Load Chart.js library -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
            // Data setup from server
            var quantity = [];
            var perfume_name = [];
            var totalprice = [];
            var date = [];
            const barColors = ["#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0"];

            <% for (Stock stock : stocks) { %>
            perfume_name.push('<%= stock.getPerfume_name().replace("'", "\\'") %>');
            quantity.push(<%= stock.getQuantity() %>);
            <% } %>

            <% for (Selling selling : sellings) { %>
            totalprice.push(<%= selling.getTotalprice() %>);
            date.push('<%= selling.getDate() %>');
            <% } %>

            // Horizontal Bar Chart for Stock Quantities
            new Chart(document.getElementById("stock"), {
                type: "bar",
                data: {
                    labels: perfume_name,
                    datasets: [{
                            label: "Stock Quantity",
                            backgroundColor: barColors,
                            data: quantity
                        }]
                },
                options: {
                    indexAxis: 'y', // Change to horizontal
                    scales: {
                        x: {beginAtZero: true}
                    },
                    plugins: {
                        legend: {display: false},
                        title: {
                            display: true,
                            text: "Top Selling Perfumes"
                        }
                    }
                }
            });

            // Bar Chart for Earnings (Vertical)
            new Chart(document.getElementById("selling"), {
                type: "bar",
                data: {
                    labels: date,
                    datasets: [{
                            label: 'Total Earnings',
                            data: totalprice,
                            backgroundColor: barColors,
                            borderColor: "#fff",
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) {
                                    return '$' + value;
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {position: 'top'},
                        tooltip: {
                            callbacks: {
                                label: function (tooltipItem) {
                                    return '$' + tooltipItem.raw.toFixed(2);
                                }
                            }
                        },
                        title: {
                            display: true,
                            text: "Total Earnings by Date"
                        }
                    }
                }
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
