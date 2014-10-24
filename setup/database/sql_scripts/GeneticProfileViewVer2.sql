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
		`genes`.`chromosomeLocEnd` AS `chromosomeLocationEnd`
    from
        ((((`genes`
        join `cancercelllines`)
        join `geneexpressions`)
        join `genecopynumbers`)
        join `genetranscripts`)
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
            and (`genes`.`DataSets_idDataSet` = 1));
