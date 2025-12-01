process DEEPMASED_PREDICT {
    tag "$sample"
    publishDir params.outdir, mode: "copy"

    conda false
    container "quay.io/biocontainers/deepmased:0.3.1--pyh5ca1d4c_0"

    input:
        tuple val(sample),
              path(feature_path_file),
              path(feature_file)

    output:
        tuple val(sample),
              path("${sample}_deepmased_predictions.tsv")

    script:
        """
        DeepMAsED predict ${feature_path_file} \\
            --n-procs ${params.cpus} \\
            --cpu-only \\
            --save-name ${sample}_deepmased
        """
}
