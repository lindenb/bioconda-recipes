#!/bin/bash
set -eu -o pipefail

outdir="$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM"
mkdir -p "${outdir}"
mkdir -p "${PREFIX}/bin"

cp -v ${SRC_DIR}/dist/*.jar "${outdir}"

cp "${RECIPE_DIR}/jvarkit.sh" "${outdir}/jvarkit"
ln -s ${outdir}/jvarkit "${PREFIX}/bin"
chmod +x "${PREFIX}/bin/jvarkit"
