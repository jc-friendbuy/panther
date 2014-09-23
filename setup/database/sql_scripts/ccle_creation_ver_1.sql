SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `ccle` ;
CREATE SCHEMA IF NOT EXISTS `ccle` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `ccle` ;

-- -----------------------------------------------------
-- Table `ccle`.`Chromosomes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`Chromosomes` ;

CREATE TABLE IF NOT EXISTS `ccle`.`Chromosomes` (
  `idChromosome` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`idChromosome`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `name_UNIQUE` ON `ccle`.`Chromosomes` (`name` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`Genes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`Genes` ;

CREATE TABLE IF NOT EXISTS `ccle`.`Genes` (
  `idGene` INT NOT NULL AUTO_INCREMENT,
  `egid` VARCHAR(20) NOT NULL,
  `symbol` VARCHAR(50) NOT NULL,
  `chromosomeLocStart` INT NOT NULL,
  `chromosomeLocEnd` INT NOT NULL,
  `Chromosomes_idChromosome` INT NOT NULL,
  PRIMARY KEY (`idGene`),
  CONSTRAINT `fk_Genes_Chromosomes`
    FOREIGN KEY (`Chromosomes_idChromosome`)
    REFERENCES `ccle`.`Chromosomes` (`idChromosome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Genes_Chromosomes_idx` ON `ccle`.`Genes` (`Chromosomes_idChromosome` ASC);

CREATE UNIQUE INDEX `egid_UNIQUE` ON `ccle`.`Genes` (`egid` ASC);

CREATE UNIQUE INDEX `symbol_UNIQUE` ON `ccle`.`Genes` (`symbol` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`CellLineSites`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`CellLineSites` ;

CREATE TABLE IF NOT EXISTS `ccle`.`CellLineSites` (
  `idCellLineSite` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idCellLineSite`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `name_UNIQUE` ON `ccle`.`CellLineSites` (`name` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`CellLineSources`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`CellLineSources` ;

CREATE TABLE IF NOT EXISTS `ccle`.`CellLineSources` (
  `idCellLineSource` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idCellLineSource`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `name_UNIQUE` ON `ccle`.`CellLineSources` (`name` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`ExpressionArrays`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`ExpressionArrays` ;

CREATE TABLE IF NOT EXISTS `ccle`.`ExpressionArrays` (
  `idExpressionArray` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`idExpressionArray`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `name_UNIQUE` ON `ccle`.`ExpressionArrays` (`name` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`SNPArrays`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`SNPArrays` ;

CREATE TABLE IF NOT EXISTS `ccle`.`SNPArrays` (
  `idSNPArray` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`idSNPArray`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `name_UNIQUE` ON `ccle`.`SNPArrays` (`name` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`CancerCellLines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`CancerCellLines` ;

CREATE TABLE IF NOT EXISTS `ccle`.`CancerCellLines` (
  `idCancerCellLine` INT NOT NULL AUTO_INCREMENT,
  `primaryName` VARCHAR(100) NOT NULL,
  `genderMale` TINYINT(1) NULL,
  `histology` VARCHAR(200) NULL,
  `histologySubtype` VARCHAR(200) NULL,
  `notes` VARCHAR(500) NULL,
  `oncomap` TINYINT(1) NULL,
  `hybridSequencing` TINYINT(1) NULL,
  `aliases` VARCHAR(500) NULL,
  `CellLineSites_idCellLineSite` INT NOT NULL,
  `CellLineSources_idCellLineSource` INT NOT NULL,
  `ExpressionArrays_idExpressionArray` INT NULL,
  `SNPArrays_idSNPArray` INT NULL,
  PRIMARY KEY (`idCancerCellLine`),
  CONSTRAINT `fk_CancerCellLines_CellLineSites1`
    FOREIGN KEY (`CellLineSites_idCellLineSite`)
    REFERENCES `ccle`.`CellLineSites` (`idCellLineSite`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CancerCellLines_Sources1`
    FOREIGN KEY (`CellLineSources_idCellLineSource`)
    REFERENCES `ccle`.`CellLineSources` (`idCellLineSource`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CancerCellLines_ExpressionArrays1`
    FOREIGN KEY (`ExpressionArrays_idExpressionArray`)
    REFERENCES `ccle`.`ExpressionArrays` (`idExpressionArray`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CancerCellLines_SNPArrays1`
    FOREIGN KEY (`SNPArrays_idSNPArray`)
    REFERENCES `ccle`.`SNPArrays` (`idSNPArray`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_CancerCellLines_CellLineSite_idx` ON `ccle`.`CancerCellLines` (`CellLineSites_idCellLineSite` ASC);

CREATE INDEX `fk_CancerCellLines_CancerCellLineSources_idx` ON `ccle`.`CancerCellLines` (`CellLineSources_idCellLineSource` ASC);

CREATE INDEX `fk_CancerCellLines_ExpressionArrays_idx` ON `ccle`.`CancerCellLines` (`ExpressionArrays_idExpressionArray` ASC);

CREATE INDEX `fk_CancerCellLines_SNPArrays_idx` ON `ccle`.`CancerCellLines` (`SNPArrays_idSNPArray` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`DataSets`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`DataSets` ;

CREATE TABLE IF NOT EXISTS `ccle`.`DataSets` (
  `idDataSet` INT NOT NULL AUTO_INCREMENT,
  `Date` DATETIME NOT NULL,
  `Description` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`idDataSet`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ccle`.`GeneCopyNumbers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`GeneCopyNumbers` ;

CREATE TABLE IF NOT EXISTS `ccle`.`GeneCopyNumbers` (
  `idGeneCopyNumber` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `snpCopyNumber2Log2` DECIMAL(7,5) NOT NULL,
  `Genes_idGene` INT NULL,
  `CancerCellLines_idCancerCellLine` INT NULL,
  `DataSets_idDataSet` INT NOT NULL,
  PRIMARY KEY (`idGeneCopyNumber`),
  CONSTRAINT `fk_GeneCopyNumbers_Genes1`
    FOREIGN KEY (`Genes_idGene`)
    REFERENCES `ccle`.`Genes` (`idGene`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GeneCopyNumbers_CancerCellLines1`
    FOREIGN KEY (`CancerCellLines_idCancerCellLine`)
    REFERENCES `ccle`.`CancerCellLines` (`idCancerCellLine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GeneCopyNumbers_DataSets1`
    FOREIGN KEY (`DataSets_idDataSet`)
    REFERENCES `ccle`.`DataSets` (`idDataSet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_GeneCopyNumbers_Genes_idx` ON `ccle`.`GeneCopyNumbers` (`Genes_idGene` ASC);

CREATE INDEX `fk_GeneCopyNumbers_CancerCellLines_idx` ON `ccle`.`GeneCopyNumbers` (`CancerCellLines_idCancerCellLine` ASC);

CREATE INDEX `fk_GeneCopyNumbers_DataSets_idx` ON `ccle`.`GeneCopyNumbers` (`DataSets_idDataSet` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`GeneExpressions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`GeneExpressions` ;

CREATE TABLE IF NOT EXISTS `ccle`.`GeneExpressions` (
  `idGeneExpression` INT NOT NULL AUTO_INCREMENT,
  `quantileNormalizedRMAExpression` DECIMAL(8,6) NOT NULL,
  `Genes_idGene` INT NULL,
  `CancerCellLines_idCancerCellLine` INT NULL,
  `DataSets_idDataSet` INT NOT NULL,
  PRIMARY KEY (`idGeneExpression`),
  CONSTRAINT `fk_GeneExpressions_Genes1`
    FOREIGN KEY (`Genes_idGene`)
    REFERENCES `ccle`.`Genes` (`idGene`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GeneExpressions_CancerCellLines1`
    FOREIGN KEY (`CancerCellLines_idCancerCellLine`)
    REFERENCES `ccle`.`CancerCellLines` (`idCancerCellLine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GeneExpressions_DataSets1`
    FOREIGN KEY (`DataSets_idDataSet`)
    REFERENCES `ccle`.`DataSets` (`idDataSet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_GeneExpressions_Genes_idx` ON `ccle`.`GeneExpressions` (`Genes_idGene` ASC);

CREATE INDEX `fk_GeneExpressions_CancerCellLines_idx` ON `ccle`.`GeneExpressions` (`CancerCellLines_idCancerCellLine` ASC);

CREATE INDEX `fk_GeneExpressions_DataSets_idx` ON `ccle`.`GeneExpressions` (`DataSets_idDataSet` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`TherapyCompounds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`TherapyCompounds` ;

CREATE TABLE IF NOT EXISTS `ccle`.`TherapyCompounds` (
  `idTherapyCompounds` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `brandName` VARCHAR(100) NULL,
  `mechanismOfAction` VARCHAR(150) NOT NULL,
  `class` ENUM('kinase inhibitor', 'other targeted therapies', 'cytotoxic') NOT NULL,
  `highestPhase` VARCHAR(45) NULL,
  `organization` VARCHAR(100) NULL,
  `target` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idTherapyCompounds`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `idTherapyCompounds_UNIQUE` ON `ccle`.`TherapyCompounds` (`idTherapyCompounds` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`DrugResponses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`DrugResponses` ;

CREATE TABLE IF NOT EXISTS `ccle`.`DrugResponses` (
  `idDrugResponse` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `fitType` ENUM('sigmoid', 'constant', 'linear') NOT NULL,
  `ec50UM` DECIMAL(10,8) NULL,
  `ic50UM` DECIMAL(10,8) NULL,
  `aMax` DECIMAL(9,6) NULL,
  `actArea` DECIMAL(6,4) NULL,
  `Genes_idGene` INT NULL,
  `CancerCellLines_idCancerCellLine` INT NULL,
  `TherapyCompounds_idTherapyCompounds` INT NOT NULL,
  `DataSets_idDataSet` INT NOT NULL,
  PRIMARY KEY (`idDrugResponse`),
  CONSTRAINT `fk_DrugResponses_CancerCellLines1`
    FOREIGN KEY (`CancerCellLines_idCancerCellLine`)
    REFERENCES `ccle`.`CancerCellLines` (`idCancerCellLine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DrugResponses_TherapyCompounds1`
    FOREIGN KEY (`TherapyCompounds_idTherapyCompounds`)
    REFERENCES `ccle`.`TherapyCompounds` (`idTherapyCompounds`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DrugResponses_Genes1`
    FOREIGN KEY (`Genes_idGene`)
    REFERENCES `ccle`.`Genes` (`idGene`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DrugResponses_DataSets1`
    FOREIGN KEY (`DataSets_idDataSet`)
    REFERENCES `ccle`.`DataSets` (`idDataSet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_DrugResponses_CancerCellLines1_idx` ON `ccle`.`DrugResponses` (`CancerCellLines_idCancerCellLine` ASC);

CREATE INDEX `fk_DrugResponses_TherapyCompounds1_idx` ON `ccle`.`DrugResponses` (`TherapyCompounds_idTherapyCompounds` ASC);

CREATE INDEX `fk_DrugResponses_Genes1_idx` ON `ccle`.`DrugResponses` (`Genes_idGene` ASC);

CREATE INDEX `fk_DrugResponses_DataSets1_idx` ON `ccle`.`DrugResponses` (`DataSets_idDataSet` ASC);


-- -----------------------------------------------------
-- Table `ccle`.`DrugResponseDoses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ccle`.`DrugResponseDoses` ;

CREATE TABLE IF NOT EXISTS `ccle`.`DrugResponseDoses` (
  `idDrugTreatment` INT NOT NULL AUTO_INCREMENT,
  `doseUM` DECIMAL(6,4) NOT NULL,
  `activityMedian` DECIMAL(6,3) NOT NULL,
  `activitySD` DECIMAL(6,3) NOT NULL,
  `DrugResponses_idDrugResponse` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idDrugTreatment`, `DrugResponses_idDrugResponse`),
  CONSTRAINT `fk_DrugResponseDoses_DrugResponses1`
    FOREIGN KEY (`DrugResponses_idDrugResponse`)
    REFERENCES `ccle`.`DrugResponses` (`idDrugResponse`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_DrugResponseDoses_DrugResponses1_idx` ON `ccle`.`DrugResponseDoses` (`DrugResponses_idDrugResponse` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
