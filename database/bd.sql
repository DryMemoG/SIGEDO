-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema climate
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema climate
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `climate` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `climate` ;

-- -----------------------------------------------------
-- Table `climate`.`tc_grupo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tc_grupo` (
  `id_grupo` INT NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_grupo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Grupo de condición climática proporcionada por OpenWheatherMap';


-- -----------------------------------------------------
-- Table `climate`.`tc_tipo_clima`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tc_tipo_clima` (
  `id_tipo_clima` INT NOT NULL COMMENT 'ID Proporcionado por OpenWeatherMap',
  `id_grupo` INT NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `icono` VARCHAR(100) NOT NULL COMMENT 'ícono',
  PRIMARY KEY (`id_tipo_clima`),
  INDEX `tc_tipo_clima_tc_grupo_FK` (`id_grupo` ASC) VISIBLE,
  CONSTRAINT `tc_tipo_clima_tc_grupo_FK`
    FOREIGN KEY (`id_grupo`)
    REFERENCES `climate`.`tc_grupo` (`id_grupo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Tipos de clima proporcionados por OpenWeatherMap Ref: https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2';


-- -----------------------------------------------------
-- Table `climate`.`tc_tipo_registro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tc_tipo_registro` (
  `id_tipo_registro` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(100) NOT NULL,
  `medida` VARCHAR(100) NOT NULL COMMENT 'Tipo de medida ej. %, C, ppm.',
  PRIMARY KEY (`id_tipo_registro`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Tipos de registros de los sensores Ej: Temperatura, Humedad, CO2, etc.';


-- -----------------------------------------------------
-- Table `climate`.`tt_clima_registrado_actual`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tt_clima_registrado_actual` (
  `id_clima` INT NOT NULL AUTO_INCREMENT,
  `datetime` DATETIME NOT NULL COMMENT 'Hora y fecha de la consulta a la API en la zona horaria',
  `temp` DECIMAL(10,0) NOT NULL COMMENT 'Temperatura registrada en ese momento del día segùn prevision climàtica',
  `hum` DECIMAL(10,0) NOT NULL COMMENT 'Porcentaje de humedad relativa',
  `sensacion` DECIMAL(10,0) NULL DEFAULT NULL COMMENT 'Sensación térmica',
  `presion` DECIMAL(10,0) NOT NULL COMMENT 'Presión atmosférica',
  `UVI` DECIMAL(10,0) NOT NULL COMMENT 'Indice de Rayos UV',
  `wind_speed` DECIMAL(10,0) NOT NULL COMMENT 'Velocidad del Viento',
  `wind_direction` DECIMAL(10,0) NOT NULL COMMENT 'Direccion en grados.',
  `weather_id` INT NOT NULL COMMENT 'Id del clima Se comunica con catálogo',
  PRIMARY KEY (`id_clima`),
  INDEX `tt_clima_registrado_actual_tc_tipo_clima_FK` (`weather_id` ASC) VISIBLE,
  CONSTRAINT `tt_clima_registrado_actual_tc_tipo_clima_FK`
    FOREIGN KEY (`weather_id`)
    REFERENCES `climate`.`tc_tipo_clima` (`id_tipo_clima`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Registros del Clima desde OpenWeatherMap Cada 15 minutos';


-- -----------------------------------------------------
-- Table `climate`.`tt_ubicacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tt_ubicacion` (
  `id_ubicacion` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(100) NOT NULL COMMENT 'Datos sobre la ubicacion',
  PRIMARY KEY (`id_ubicacion`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Tabla con las ubicaciones de la casa.';


-- -----------------------------------------------------
-- Table `climate`.`tt_nodo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tt_nodo` (
  `id_nodo` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(100) NOT NULL COMMENT 'Datos respecto a la información del Nodo',
  `direccion_ip` VARCHAR(15) NOT NULL COMMENT 'Dirección IP del Nodo',
  `id_ubicacion` INT NOT NULL COMMENT 'id de la ubicación en la que se encuentra',
  PRIMARY KEY (`id_nodo`),
  UNIQUE INDEX `Nodo_unique` (`direccion_ip` ASC) VISIBLE,
  INDEX `tt_nodo_tt_ubicacion_FK` (`id_ubicacion` ASC) VISIBLE,
  CONSTRAINT `tt_nodo_tt_ubicacion_FK`
    FOREIGN KEY (`id_ubicacion`)
    REFERENCES `climate`.`tt_ubicacion` (`id_ubicacion`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Listado de los nodos registrados.';


-- -----------------------------------------------------
-- Table `climate`.`tt_tipo_sensor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tt_tipo_sensor` (
  `id_tipo_sensor` INT NOT NULL AUTO_INCREMENT,
  `modelo` VARCHAR(100) NOT NULL COMMENT 'Modelo del Sensor',
  `fabricante` VARCHAR(100) NOT NULL COMMENT 'Fabricante del Sensor',
  PRIMARY KEY (`id_tipo_sensor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Guarda los tipos de sensores que se usan para medir las distintas cosas.';


-- -----------------------------------------------------
-- Table `climate`.`tt_sensor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tt_sensor` (
  `id_sensor` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(100) NOT NULL COMMENT 'Datos del Sensor',
  `serial_number` VARCHAR(100) NOT NULL COMMENT 'Numero de serie para mas información',
  `id_tipo` INT NOT NULL COMMENT 'Tipo de Sensor',
  `id_nodo` INT NOT NULL COMMENT 'Nodo al que pertenece',
  PRIMARY KEY (`id_sensor`),
  INDEX `tt_sensor_tt_tipo_sensor_FK` (`id_tipo` ASC) VISIBLE,
  INDEX `tt_sensor_tt_nodo_FK` (`id_nodo` ASC) VISIBLE,
  CONSTRAINT `tt_sensor_tt_nodo_FK`
    FOREIGN KEY (`id_nodo`)
    REFERENCES `climate`.`tt_nodo` (`id_nodo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `tt_sensor_tt_tipo_sensor_FK`
    FOREIGN KEY (`id_tipo`)
    REFERENCES `climate`.`tt_tipo_sensor` (`id_tipo_sensor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Registro de los sensores utilizados para métricas';


-- -----------------------------------------------------
-- Table `climate`.`tt_registro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `climate`.`tt_registro` (
  `id_registro` INT NOT NULL AUTO_INCREMENT,
  `id_tipo_registro` INT NOT NULL,
  `valor` DECIMAL(10,0) NOT NULL,
  `id_sensor` INT NOT NULL,
  `timestamp` DATETIME NOT NULL,
  PRIMARY KEY (`id_registro`),
  INDEX `tt_registro_id_tipo_registro_IDX` USING BTREE (`id_tipo_registro`) VISIBLE,
  INDEX `tt_registro_id_sensor_IDX` USING BTREE (`id_sensor`) VISIBLE,
  CONSTRAINT `tt_registro_tc_tipo_registro_FK`
    FOREIGN KEY (`id_tipo_registro`)
    REFERENCES `climate`.`tc_tipo_registro` (`id_tipo_registro`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `tt_registro_tt_sensor_FK`
    FOREIGN KEY (`id_sensor`)
    REFERENCES `climate`.`tt_sensor` (`id_sensor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci
COMMENT = 'Registro de cada uno de los sensores.';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
