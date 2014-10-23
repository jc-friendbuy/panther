CREATE 
    ALGORITHM = UNDEFINED 
VIEW `geneticprofileview` AS
    select 
        `Genes`.`symbol` AS `symbol`,
        `CancerCellLines`.`ccleName` AS `ccleName`,
        `GeneExpressions`.`quantileNormalizedRMAExpression` AS `quantileNormalizedRMAExpression`,
        `GeneCopyNumbers`.`snpCopyNumber2Log2` AS `snpCopyNumber2Log2`
    from
        ((((`Genes`
        join `CancerCellLines`)
        join `GeneExpressions`)
        join `GeneCopyNumbers`)
        join `GeneTranscripts`)
    where
        ((`Genes`.`idGene` = `GeneCopyNumbers`.`Genes_idGene`)
            and (`Genes`.`idGene` = `GeneTranscripts`.`Genes_idGene`)
            and (`GeneTranscripts`.`idGeneTranscript` = `GeneExpressions`.`GeneTranscripts_idGeneTranscript`)
            and (`GeneExpressions`.`CancerCellLines_idCancerCellLine` = `CancerCellLines`.`idCancerCellLine`)
            and (`GeneCopyNumbers`.`CancerCellLines_idCancerCellLine` = `CancerCellLines`.`idCancerCellLine`)
            and (`GeneCopyNumbers`.`DataSets_idDataSet` = `Genes`.`DataSets_idDataSet`)
            and (`GeneExpressions`.`DataSets_idDataSet` = `Genes`.`DataSets_idDataSet`)
            and (`GeneExpressions`.`DataSets_idDataSet` = `GeneTranscripts`.`DataSets_idDataSet`)
            and (`CancerCellLines`.`DataSets_idDataSet` = `GeneCopyNumbers`.`DataSets_idDataSet`)
            and (`CancerCellLines`.`DataSets_idDataSet` = `GeneExpressions`.`DataSets_idDataSet`)
            and (`Genes`.`DataSets_idDataSet` = 1))