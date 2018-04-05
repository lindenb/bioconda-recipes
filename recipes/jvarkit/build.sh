#!/bin/bash
set -eu -o pipefail

outdir=$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM

mkdir -p "${outdir}/dist"
mkdir -p "${PREFIX}/bin"
make vcffilterjdk bioalcidaejdk samjdk vcf2table prettysam groupbygene bam2raster \
	bam2svg findavariation illuminadir ngsfilessummary sam2tsv vcfpeekvcf \
	vcf2svg lowresbam2raster vcffilterso xsltstream vcfserver tviewserver indexcovjfx tview cytoband2svg \
	standalone=yes dist.dir=${outdir}/dist

#problem with full path detected in shells
find ${outdir}/dist -type f  \! -name "*.jar" -delete

cp "${RECIPE_DIR}/jvarkit.sh" "${outdir}/dist/jvarkit"
chmod +x "${outdir}/dist/jvarkit"
ln -s "${outdir}/dist/jvarkit" "${PREFIX}/bin"
