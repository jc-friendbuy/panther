select Genes.symbol, CancerCellLines.ccleName,
    GeneExpressions.quantileNormalizedRMAExpression,
    GeneCopyNumbers.snpCopyNumber2Log2
from Genes, CancerCellLines, GeneExpressions, GeneCopyNumbers, GeneTranscripts
where Genes.idGene = GeneCopyNumbers.Genes_idGene
  and Genes.idGene = GeneTranscripts.Genes_idGene
  and GeneTranscripts.idGeneTranscript = GeneExpressions.GeneTranscripts_idGeneTranscript
  and GeneExpressions.CancerCellLines_idCancerCellLine = CancerCellLines.idCancerCellLine
  and GeneCopyNumbers.CancerCellLines_idCancerCellLine = CancerCellLines.idCancerCellLine
  and GeneCopyNumbers.DataSets_idDataset = Genes.DataSets_idDataSet
  and GeneExpressions.DataSets_idDataset = Genes.DataSets_idDataSet
  and GeneExpressions.DataSets_idDataset = GeneTranscripts.DataSets_idDataSet
  and CancerCellLines.DataSets_idDataset = GeneCopyNumbers.DataSets_idDataSet
  and CancerCellLines.DataSets_idDataset = GeneExpressions.DataSets_idDataSet
  and Genes.DataSets_idDataSet = 1;
