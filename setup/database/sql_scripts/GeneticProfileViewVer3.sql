CREATE TABLE `GeneticProfileMatView` (
  `symbol` varchar(50) NOT NULL,
  `ccleName` varchar(100) NOT NULL,
  `quantileNormalizedRMAExpression` decimal(8,6) NOT NULL,
  `snpCopyNumber2Log2` decimal(7,5) NOT NULL,
  `chromosomeLocationStart` int(11) NOT NULL,
  `chromosomeLocationEnd` int(11) NOT NULL,
  `chromosome` varchar(5) NOT NULL,
  KEY `GeneticProfileMatView_idxSymbol` (`symbol`),
  KEY `GeneticProfileMatView_idxCCLEName` (`ccleName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `jc`@`localhost` 
    SQL SECURITY DEFINER
VIEW `geneticprofileview` AS
    select 
        `genes`.`symbol` AS `symbol`,
        `cancercelllines`.`ccleName` AS `ccleName`,
        `geneexpressions`.`quantileNormalizedRMAExpression` AS `quantileNormalizedRMAExpression`,
        `genecopynumbers`.`snpCopyNumber2Log2` AS `snpCopyNumber2Log2`,
        `genes`.`chromosomeLocStart` AS `chromosomeLocationStart`,
        `genes`.`chromosomeLocEnd` AS `chromosomeLocationEnd`,
		`chromosomes`.`name` as `chromosome`
    from
        (((((`genes`
        join `cancercelllines`)
        join `geneexpressions`)
        join `genecopynumbers`)
        join `genetranscripts`)
		join `chromosomes`)
    where
        ((`genes`.`idGene` = `genecopynumbers`.`Genes_idGene`)
            and (`genes`.`idGene` = `genetranscripts`.`Genes_idGene`)
            and (`genetranscripts`.`idGeneTranscript` = `geneexpressions`.`GeneTranscripts_idGeneTranscript`)
            and (`geneexpressions`.`CancerCellLines_idCancerCellLine` = `cancercelllines`.`idCancerCellLine`)
            and (`genecopynumbers`.`CancerCellLines_idCancerCellLine` = `cancercelllines`.`idCancerCellLine`)
            and (`genecopynumbers`.`DataSets_idDataSet` = `genes`.`DataSets_idDataSet`)
            and (`geneexpressions`.`DataSets_idDataSet` = `genes`.`DataSets_idDataSet`)
            and (`geneexpressions`.`DataSets_idDataSet` = `genetranscripts`.`DataSets_idDataSet`)
            and (`cancercelllines`.`DataSets_idDataSet` = `genecopynumbers`.`DataSets_idDataSet`)
            and (`cancercelllines`.`DataSets_idDataSet` = `geneexpressions`.`DataSets_idDataSet`)
			and (`genes`.`Chromosomes_idChromosome` = `chromosomes`.`idChromosome`)
            and (`genes`.`DataSets_idDataSet` = 1));



insert into `GeneticProfileMatView` select * from `geneticprofileview`;
