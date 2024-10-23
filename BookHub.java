package gui;

import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.sql.*;

public class BookHub extends Application {
    private TableView<Admin> adminTableView;

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("Admin Database Viewer");

        adminTableView = new TableView<>();
        createAdminTable();

        Button addButton = new Button("Add Admin");
        addButton.setOnAction(e -> addAdminDialog());

        Button updateButton = new Button("Update Admin");
        updateButton.setOnAction(e -> updateAdminDialog());

        Button deleteButton = new Button("Delete Admin");
        deleteButton.setOnAction(e -> deleteAdmin());

        VBox vbox = new VBox(addButton, updateButton, deleteButton, adminTableView);

        Scene scene = new Scene(vbox, 800, 600);
        primaryStage.setScene(scene);

        primaryStage.show();

        fetchAdminData();
    }

    private void createAdminTable() {
        TableColumn<Admin, String> emailColumn = new TableColumn<>("Admin Email");
        emailColumn.setCellValueFactory(new PropertyValueFactory<>("adminEmail"));

        TableColumn<Admin, String> nameColumn = new TableColumn<>("Admin Name");
        nameColumn.setCellValueFactory(new PropertyValueFactory<>("adminName"));

        TableColumn<Admin, String> passwordColumn = new TableColumn<>("Admin Password");
        passwordColumn.setCellValueFactory(new PropertyValueFactory<>("adminPassword"));

        adminTableView.getColumns().addAll(emailColumn, nameColumn, passwordColumn);
    }

    private void fetchAdminData() {
        try {
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_hub", "root", "");
            String query = "SELECT * FROM admin";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            ResultSet resultSet = preparedStatement.executeQuery();

            ObservableList<Admin> adminList = FXCollections.observableArrayList();

            while (resultSet.next()) {
                String adminEmail = resultSet.getString("admin_email");
                String adminName = resultSet.getString("admin_name");
                String adminPassword = resultSet.getString("admin_password");

                Admin admin = new Admin(adminEmail, adminName, adminPassword);
                adminList.add(admin);
            }

            adminTableView.setItems(adminList);

            resultSet.close();
            preparedStatement.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void addAdminDialog() {
        Dialog<Admin> dialog = new Dialog<>();
        dialog.setTitle("Add Admin");

        ButtonType addButton = new ButtonType("Add", ButtonBar.ButtonData.OK_DONE);
        dialog.getDialogPane().getButtonTypes().addAll(addButton, ButtonType.CANCEL);

        TextField emailField = new TextField();
        TextField nameField = new TextField();
        TextField passwordField = new TextField();

        dialog.getDialogPane().setContent(new VBox(new Label("Admin Email"), emailField,
                new Label("Admin Name"), nameField,
                new Label("Admin Password"), passwordField));

        dialog.setResultConverter(dialogButton -> {
            if (dialogButton == addButton) {
                return new Admin(emailField.getText(), nameField.getText(), passwordField.getText());
            }
            return null;
        });

        dialog.showAndWait().ifPresent(this::insertAdmin);
    }

    private void insertAdmin(Admin admin) {
        try {
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_hub", "root", "");
            String query = "INSERT INTO admin (admin_email, admin_name, admin_password) VALUES (?, ?, ?)";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, admin.getAdminEmail());
            preparedStatement.setString(2, admin.getAdminName());
            preparedStatement.setString(3, admin.getAdminPassword());

            preparedStatement.executeUpdate();

            preparedStatement.close();
            connection.close();

            fetchAdminData();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateAdminDialog() {
        Admin selectedAdmin = adminTableView.getSelectionModel().getSelectedItem();

        if (selectedAdmin == null) {
            showAlert("No Admin Selected", "Please select an admin to update.");
            return;
        }

        Dialog<Admin> dialog = new Dialog<>();
        dialog.setTitle("Update Admin");

        ButtonType updateButton = new ButtonType("Update", ButtonBar.ButtonData.OK_DONE);
        dialog.getDialogPane().getButtonTypes().addAll(updateButton, ButtonType.CANCEL);

        TextField emailField = new TextField(selectedAdmin.getAdminEmail());
        TextField nameField = new TextField(selectedAdmin.getAdminName());
        TextField passwordField = new TextField(selectedAdmin.getAdminPassword());

        dialog.getDialogPane().setContent(new VBox(new Label("Admin Email"), emailField,
                new Label("Admin Name"), nameField,
                new Label("Admin Password"), passwordField));

        dialog.setResultConverter(dialogButton -> {
            if (dialogButton == updateButton) {
                return new Admin(emailField.getText(), nameField.getText(), passwordField.getText());
            }
            return null;
        });

        dialog.showAndWait().ifPresent(updatedAdmin -> updateAdmin(selectedAdmin, updatedAdmin));
    }

    private void updateAdmin(Admin oldAdmin, Admin updatedAdmin) {
        try {
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_hub", "root", "");
            String query = "UPDATE admin SET admin_email=?, admin_name=?, admin_password=? WHERE admin_email=?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, updatedAdmin.getAdminEmail());
            preparedStatement.setString(2, updatedAdmin.getAdminName());
            preparedStatement.setString(3, updatedAdmin.getAdminPassword());
            preparedStatement.setString(4, oldAdmin.getAdminEmail());

            preparedStatement.executeUpdate();

            preparedStatement.close();
            connection.close();

            fetchAdminData();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void deleteAdmin() {
        Admin selectedAdmin = adminTableView.getSelectionModel().getSelectedItem();

        if (selectedAdmin == null) {
            showAlert("No Admin Selected", "Please select an admin to delete.");
            return;
        }

        try {
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_hub", "root", "");
            String query = "DELETE FROM admin WHERE admin_email=?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, selectedAdmin.getAdminEmail());

            preparedStatement.executeUpdate();

            preparedStatement.close();
            connection.close();

            fetchAdminData();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static class Admin {
        private final String adminEmail;
        private final String adminName;
        private final String adminPassword;

        public Admin(String email, String name, String password) {
            this.adminEmail = email;
            this.adminName = name;
            this.adminPassword = password;
        }

        public String getAdminEmail() {
            return adminEmail;
        }

        public String getAdminName() {
            return adminName;
        }

        public String getAdminPassword() {
            return adminPassword;
        }
    }

    private void showAlert(String title, String content) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(content);
        alert.showAndWait();
    }
}
