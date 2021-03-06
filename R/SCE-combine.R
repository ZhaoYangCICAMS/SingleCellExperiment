#' @export
#' @importFrom S4Vectors SimpleList
#' @importClassesFrom SummarizedExperiment RangedSummarizedExperiment
setMethod("cbind", "SingleCellExperiment", function(..., deparse.level=1) {
    args <- unname(list(...))
    base <- do.call(cbind, lapply(args, function(x) { as(x, "RangedSummarizedExperiment") }))

    all.col.data <- lapply(args, int_colData)
    sout <- do.call(.standardize_DataFrames, all.col.data)
    new.col.data <- do.call(rbind, sout)

    all.rd <- do.call(.standardize_reducedDims, args)
    new.rd <- SimpleList(do.call(mapply, c(all.rd, FUN=rbind, SIMPLIFY=FALSE)))

    ans <- args[[1]]
    new(class(ans), base, int_colData=new.col.data, int_elementMetadata=int_elementMetadata(ans),
        int_metadata=int_metadata(ans), reducedDims=new.rd)
})

#' @export
#' @importClassesFrom SummarizedExperiment RangedSummarizedExperiment
setMethod("rbind", "SingleCellExperiment", function(..., deparse.level=1) {
    args <- unname(list(...))
    base <- do.call(rbind, lapply(args, function(x) { as(x, "RangedSummarizedExperiment") }))

    all.row.data <- lapply(args, int_elementMetadata)
    sout <- do.call(.standardize_DataFrames, all.row.data)
    new.row.data <- do.call(rbind, sout)

    ans <- args[[1]]
    new(class(ans), base, int_colData=int_colData(ans), int_elementMetadata=new.row.data,
        int_metadata=int_metadata(ans), reducedDims=reducedDims(ans, withDimnames=FALSE))
})
