#' The First 100 Single Nucleotide Polymorphism Mutations In The UCS.mutations Dataset
#'
#' Uterine Carcinosarcoma (UCS) Mutations datasets from The Cancer Genome Atlas Project 2015-11-01 snapshot.
#'
#' @source The Cancer Genome Atlas (TCGA) Program.
#'
#' @references
#' #' Kosinski M (2024). _RTCGA.mutations: Mutations datasets from The Cancer Genome Atlas Project_.
#' doi:10.18129/B9.bioc.RTCGA.mutations <https://doi.org/10.18129/B9.bioc.RTCGA.mutations>, R package version
#' 20151101.34.0, <https://bioconductor.org/packages/RTCGA.mutations>
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{Chromosome}{The chromosome on which the mutation is located.}
#'   \item{Start_position}{The starting position of the mutation on the chromosome.}
#'   \item{Reference_Allele}{The base(s) found on the reference genome at the mutation position.}
#'   \item{Tumor_Seq_Allele2}{The observed allele sequence in the tumor sample at the mutation position.}
#'   \item{Tumor_Sample_Barcode}{A unique identifier for the tumor sample in which the mutation was detected.}
#'   \item{SNP_mutation}{The last three characters of the `Genome_Change` column, representing the single nucleotide polymorphism (SNP) mutation type (e.g., "G>T").}
#'   \item{Variant_Type}{The type of mutation, such as single nucleotide polymorphism (SNP), deletion, or insertion.}
#' }
#'
#' @examples
#' \dontrun{
#'  filteredUCSFirst100SNP
#' }
"filteredUCSFirst100SNP"

#' UCS.mutations Dataset From the RTCGA.mutations Package
#'
#' Uterine Carcinosarcoma (UCS) Mutations datasets from The Cancer Genome Atlas Project 2015-11-01 snapshot.
#'
#' @source The Cancer Genome Atlas (TCGA) Program.
#'
#' @references
#' Kosinski M (2024). _RTCGA.mutations: Mutations datasets from The Cancer Genome Atlas Project_.
#' doi:10.18129/B9.bioc.RTCGA.mutations <https://doi.org/10.18129/B9.bioc.RTCGA.mutations>, R package version
#' 20151101.34.0, <https://bioconductor.org/packages/RTCGA.mutations>
#'
#' @format A data frame with multiple rows and the following columns:
#' \describe{
#'   \item{Hugo_Symbol}{Gene symbol associated with the mutation.}
#'   \item{Entrez_Gene_Id}{Entrez gene ID for the mutated gene.}
#'   \item{Center}{Research center that generated the data.}
#'   \item{NCBI_Build}{NCBI genome build version used for alignment (e.g., hg19).}
#'   \item{Chromosome}{The chromosome on which the mutation is located (e.g., "chr1", "chr2").}
#'   \item{Start_position}{The starting genomic position of the mutation.}
#'   \item{End_position}{The ending genomic position of the mutation.}
#'   \item{Strand}{Strand on which the mutation occurs, either "+" or "-".}
#'   \item{Variant_Classification}{Classification of the mutation (e.g., missense, nonsense).}
#'   \item{Variant_Type}{The type of mutation, such as SNP, insertion, or deletion.}
#'   \item{Reference_Allele}{The reference allele sequence at the mutation site.}
#'   \item{Tumor_Seq_Allele1}{The sequence of the first tumor allele at the mutation site.}
#'   \item{Tumor_Seq_Allele2}{The sequence of the second tumor allele at the mutation site.}
#'   \item{dbSNP_RS}{Reference SNP ID from dbSNP database.}
#'   \item{Tumor_Sample_Barcode}{Unique identifier for the tumor sample containing the mutation.}
#' }
#'
#' @examples
#' \dontrun{
#'  UCS.mutations
#' }
"UCS.mutations"
# [END] written by Keren Zhang
