#!/bin/bash

outdir=$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM

mkdir -p "${outdir}/dist"
make vcffilterjdk bioalcidaejdk samjdk vcf2table prettysam standalone=yes dist.dir=${outdir}/dist
cp jvarkit.sh "${outdir}/dist/jvarkit"

