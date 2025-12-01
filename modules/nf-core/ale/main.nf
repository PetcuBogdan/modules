process ALE {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${
        workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ale-core:20220503--h577a1d6_1' :
        'quay.io/biocontainers/ale-core:20220503--h577a1d6_1'
    }"

    input:
    tuple val(meta), path(asm), path(bam)

    output:
    tuple val(meta), path("${meta.id}_ALEoutput.txt"), emit: ale
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix  = task.ext.prefix ?: "${meta.id}"
    def VERSION = '20220503'

    """
    ALE \\
        ${bam} \\
        ${asm} \\
        ${prefix}_ALEoutput.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ale-core: $VERSION
    END_VERSIONS
    """
}
