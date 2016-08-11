-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema SAD
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema SAD
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `SAD` DEFAULT CHARACTER SET utf8 ;
USE `SAD` ;

-- -----------------------------------------------------
-- Table `SAD`.`Professores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Professores` (
  `idt_prof` INT NOT NULL,
  `mat_prof` INT NOT NULL,
  `nom_prof` TEXT(60) NOT NULL,
  PRIMARY KEY (`idt_prof`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAD`.`Cursos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Cursos` (
  `cod_curso` INT NOT NULL,
  `nom_curso` TEXT(60) NOT NULL,
  `tod_cred` INT NOT NULL,
  `idt_prof` INT NOT NULL,
  PRIMARY KEY (`cod_curso`),
  INDEX `idf_prof_idx` (`idt_prof` ASC),
  CONSTRAINT `idf_prof`
    FOREIGN KEY (`idt_prof`)
    REFERENCES `SAD`.`Professores` (`idt_prof`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAD`.`Alunos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Alunos` (
  `mat_alu` INT NOT NULL,
  `nom_alu` TEXT(60) NOT NULL,
  `tot_cred` INT NOT NULL,
  `mgp` FLOAT NOT NULL,
  `cod_curso` INT NOT NULL,
  PRIMARY KEY (`mat_alu`),
  INDEX `cod_curso_idx` (`cod_curso` ASC),
  CONSTRAINT `cod_curso`
    FOREIGN KEY (`cod_curso`)
    REFERENCES `SAD`.`Cursos` (`cod_curso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAD`.`Disciplinas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Disciplinas` (
  `cod_disc` INT NOT NULL,
  `nom_disc` TEXT(60) NOT NULL,
  `creditos` INT NOT NULL,
  `tipo_disc` TEXT(60) NOT NULL,
  `horas_obrig` INT NULL,
  `limites_faltas` INT NULL,
  `cod_disc_pre` INT NULL,
  PRIMARY KEY (`cod_disc`),
  INDEX `cod_disc_pre_idx` (`cod_disc_pre` ASC))
ENGINE = InnoDB;

ALTER TABLE `SAD`.`Disciplinas` ADD 
  CONSTRAINT `cod_disc_pre`
    FOREIGN KEY (`cod_disc_pre`)
    REFERENCES `SAD`.`Disciplinas` (`cod_disc`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

-- -----------------------------------------------------
-- Table `SAD`.`Matrizes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Matrizes` (
  `cod_disc` INT NOT NULL,
  `cod_curso` INT NOT NULL,
  `periodo` INT NOT NULL,
  PRIMARY KEY (`cod_disc`, `cod_curso`),
  INDEX `cod_curso_idx` (`cod_curso` ASC),
  CONSTRAINT `cod_curso`
    FOREIGN KEY (`cod_curso`)
    REFERENCES `SAD`.`Cursos` (`cod_curso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cod_disc`
    FOREIGN KEY (`cod_disc`)
    REFERENCES `SAD`.`Disciplinas` (`cod_disc`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAD`.`Periodos_letivos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Periodos_letivos` (
  `ano` INT NOT NULL,
  `semestre` INT NOT NULL,
  `dat_ini` DATE NOT NULL,
  `dat_fim` DATE NOT NULL,
  PRIMARY KEY (`ano`, `semestre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAD`.`Turmas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Turmas` (
  `semestre` INT NOT NULL,
  `ano` INT NOT NULL,
  `cod_disc` INT NOT NULL,
  `turma` TEXT(60) NOT NULL,
  `vagas` INT NOT NULL,
  `idt_prof` INT NULL,
  PRIMARY KEY (`semestre`, `ano`, `cod_disc`, `turma`),
  INDEX `ano_idx` (`ano` ASC),
  INDEX `cod_disc_idx` (`cod_disc` ASC),
  INDEX `idt_prof_idx` (`idt_prof` ASC),
  CONSTRAINT `semestre`
    FOREIGN KEY (`semestre`)
    REFERENCES `SAD`.`Periodos_letivos` (`semestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ano`
    FOREIGN KEY (`ano`)
    REFERENCES `SAD`.`Periodos_letivos` (`ano`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cod_disc`
    FOREIGN KEY (`cod_disc`)
    REFERENCES `SAD`.`Disciplinas` (`cod_disc`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idt_prof`
    FOREIGN KEY (`idt_prof`)
    REFERENCES `SAD`.`Professores` (`idt_prof`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SAD`.`Matriculas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Matriculas` (
  `ano` INT(4) NOT NULL,
  `semestre` INT NOT NULL,
  `cod_disc` INT NOT NULL,
  `mat_alu` INT NOT NULL,
  `turma` TEXT(60) NOT NULL,
  `faltas1` INT NULL,
  `faltas2` INT NULL,
  `faltas3` INT NULL,
  `notas1` REAL NULL,
  `notas2` REAL NULL,
  `notas3` REAL NULL,
  PRIMARY KEY (`ano`, `semestre`, `cod_disc`, `mat_alu`),
  INDEX `mat_alu_idx` (`mat_alu` ASC),
  INDEX `semestre_idx` (`semestre` ASC),
  INDEX `cod_disc_idx` (`cod_disc` ASC),
  CONSTRAINT `mat_alu`
    FOREIGN KEY (`mat_alu`)
    REFERENCES `SAD`.`Alunos` (`mat_alu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ano`
    FOREIGN KEY (`ano`)
    REFERENCES `SAD`.`Turmas` (`ano`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `semestre`
    FOREIGN KEY (`semestre`)
    REFERENCES `SAD`.`Turmas` (`semestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cod_disc`
    FOREIGN KEY (`cod_disc`)
    REFERENCES `SAD`.`Turmas` (`cod_disc`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = swe7;


-- -----------------------------------------------------
-- Table `SAD`.`Historicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SAD`.`Historicos` (
  `ano` INT NOT NULL,
  `semestre` INT NOT NULL,
  `mat_alu` INT NOT NULL,
  `cod_disc` INT NOT NULL,
  `situacao` TEXT(60) NOT NULL,
  `media` REAL NOT NULL,
  `faltas` INT NOT NULL,
  PRIMARY KEY (`ano`, `semestre`, `mat_alu`, `cod_disc`),
  INDEX `mat_alu_idx` (`mat_alu` ASC),
  INDEX `cod_disc_idx` (`cod_disc` ASC),
  INDEX `semestre_idx` (`semestre` ASC),
  CONSTRAINT `mat_alu`
    FOREIGN KEY (`mat_alu`)
    REFERENCES `SAD`.`Alunos` (`mat_alu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cod_disc`
    FOREIGN KEY (`cod_disc`)
    REFERENCES `SAD`.`Disciplinas` (`cod_disc`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ano`
    FOREIGN KEY (`ano`)
    REFERENCES `SAD`.`Periodos_letivos` (`ano`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `semestre`
    FOREIGN KEY (`semestre`)
    REFERENCES `SAD`.`Periodos_letivos` (`semestre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
