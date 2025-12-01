process DEEPMASED_FEATURES {
    tag "$sample"
    publishDir params.outdir, mode: "copy"

    conda false
    container "quay.io/biocontainers/deepmased:0.3.1--pyh5ca1d4c_0"

    input:
        tuple val(sample), val(basename), path(bam), path(bai), path(fasta)

    output:
        tuple val(sample),
              path("${sample}_feature_file_paths.tsv"),
              path("${basename}_feats.tsv")

    script:
        """
        echo -e "bam\\tfasta" > ${sample}_file_paths.tsv
        echo -e "${bam}\\t${fasta}" >> ${sample}_file_paths.tsv

        DeepMAsED features ${sample}_file_paths.tsv \\
            -p ${params.cpus} \\
            -o . \\
            -n ${sample}_feature_file_paths.tsv
        """
}
