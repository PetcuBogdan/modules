process DEEPMASED {
    tag "$meta.id"
    label 'process_medium'

    conda false
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/deepmased:0.3.1--pyh5ca1d4c_0' :
        'quay.io/biocontainers/deepmased:0.3.1--pyh5ca1d4c_0' }"

    input:
        tuple val(meta), path(bam), path(bai), path(fasta)

    output:
        tuple val(meta), path("${meta.id}_feature_file_paths.tsv"), emit: feature_paths
        tuple val(meta), path("${meta.id}_feats.tsv"), emit: features
        tuple val(meta), path("${meta.id}_predictions.tsv"), emit: predictions
        path "versions.yml", emit: versions

    script:
        """
        ## Step 1: Feature extraction
        deepmased features \\
            ${bam} \\
            ${fasta} \\
            --threads ${task.cpus}

        BASENAME=\$(basename ${fasta} | sed 's/\\.[^.]*\$//')

        mv \${BASENAME}_feature_file_paths.tsv  ${meta.id}_feature_file_paths.tsv
        mv \${BASENAME}_feats.tsv               ${meta.id}_feats.tsv

        ## Step 2: Prediction
        deepmased predict \\
            ${meta.id}_feature_file_paths.tsv \\
            --threads ${task.cpus} \\
            --cpu-only

        PRED=\$(ls *_predictions.tsv | head -1)
        mv \$PRED ${meta.id}_predictions.tsv

        ## Version info
        echo "deepmased: \$(deepmased --version)" > versions.yml
        """
}
