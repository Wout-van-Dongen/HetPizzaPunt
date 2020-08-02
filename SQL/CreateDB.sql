-- -----------------------------------------------------
-- Database Het Pizza Punt -----------------------------
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS HetPizzaPunt
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE HetPizzaPunt;


/* klant-gerelateerde data */
CREATE TABLE Addresses(
    AddressId INT NOT NULL PRIMARY KEY,
    straatnaam VARCHAR(255) NOT NULL,
    huisnummer SMALLINT UNSIGNED NOT NULL,
    postbus VARCHAR(3) NOT NULL,
    gemeente VARCHAR(255) NOT NULL,
    postcode VARCHAR(4) NOT NULL
)ENGINE = InnoDB;

CREATE TABLE Users(
    userId INT AUTO_INCREMENT PRIMARY KEY,
    eMail VARCHAR(255) NOT NULL UNIQUE,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    password LONGTEXT NOT NULL,
    addressId INT NOT NULL,
    INDEX idx_Users_eMail(eMail ASC),
    CONSTRAINT fk_Users_Adresses
        FOREIGN KEY(addressId)
        REFERENCES Addresses(addressId)
)ENGINE = InnoDB;

CREATE TABLE Permissions(
    permissionId VARCHAR(255) PRIMARY KEY
)ENGINE = InnoDB;

CREATE TABLE UserPermissions(
    userId INT NOT NULL,
    permissionId VARCHAR(255) NOT NULL,
    PRIMARY KEY(userId, permissionId),
    CONSTRAINT fk_UserPermissions_Users
        FOREIGN KEY(userId)
        REFERENCES Users(userId),
    CONSTRAINT fk_UserPermissions_Permissions
        FOREIGN KEY(permissionId)
        REFERENCES Permissions(permissionId)
)ENGINE = InnoDB;

/* Product-gerelateerde data */
CREATE TABLE Products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    price DECIMAL(6,2) UNSIGNED NOT NULL,
    image VARCHAR(255) NOT NULL DEFAULT 'product_default.png',
    availabilityStartDate DATE NOT NULL,
    AvailabilityEndDate DATE NOT NULL,
    INDEX idx_Products_name(name ASC)
)ENGINE = InnoDB;

CREATE TABLE Categories(
    categoryId VARCHAR(255) NOT NULL PRIMARY KEY
)ENGINE = InnoDB;

CREATE TABLE ProductCategories(
    productId INT NOT NULL,
    categoryId VARCHAR(255) NOT NULL,
    PRIMARY KEY(productId, categoryId),
    CONSTRAINT fk_ProductCategories_Products
        FOREIGN KEY (productId)
        REFERENCES Products(productId),
    CONSTRAINT fk_ProductCategories_Categories
        FOREIGN KEY (categoryId)
        REFERENCES Categories(categoryId)
)ENGINE = InnoDB;

CREATE TABLE Allergens(
    allergenId VARCHAR(255) PRIMARY KEY
)ENGINE = InnoDB;

CREATE TABLE ProductAllergens(
    productId INT NOT NULL,
    allergenId VARCHAR(255) NOT NULL,
    PRIMARY KEY(productId, allergenId),
    CONSTRAINT fk_PoductAllergens_Products
        FOREIGN KEY(productId)
        REFERENCES Products(productId),
    CONSTRAINT fk_ProductAllergens_Allergens
        FOREIGN KEY(allergenId)
        REFERENCES Allergens(allergenId)
)ENGINE = InnoDB;

CREATE TABLE Orders(
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    timeStamp TIMESTAMP NOT NULL,
    userId INT NOT NULL,
    CONSTRAINT fk_Orders_Users
        FOREIGN KEY(userId)
        REFERENCES Users(userId)
)ENGINE = InnoDB;

CREATE TABLE OrderProducts(
    orderId INT NOT NULL,
    productId INT NOT NULL,
    ammount TINYINT UNSIGNED NOT NULL,
    unitPrice DECIMAL(6,2) UNSIGNED NOT NULL,
    PRIMARY KEY(orderId, productId),
    CONSTRAINT fk_OrderProducts_Orders
        FOREIGN KEY(orderId)
        REFERENCES Orders(orderId),
    CONSTRAINT fk_OrderProducts_Products
        FOREIGN KEY(productId)
        REFERENCES Products(productId)
)ENGINE = InnoDB;

/* Creating a user for the application to access the database */
CREATE USER 'DigiChef'@'localhost' IDENTIFIED BY 'BytesAndNibbles';
GRANT SELECT, INSERT, UPDATE, DELETE ON `PizzaPunt`.* TO 'DigiChef'@'localhost';
