#!/bin/bash
#
# Script to generate a signed dtbo image for OPlus MediaTek devices

# Define colors
declare -A colors=(
    [red]='\033[0;31m'
    [green]='\033[0;32m'
    [yellow]='\033[0;33m'
    [blue]='\033[0;34m'
    [purple]='\033[0;35m'
    [clear]='\033[0m'
)

# Global variables
dtbo_support_list="k6983v1_64 oplus6983_21007 oplus6983_22021 oplus6983_22021_EVB oplus6983_22921 oplus6983_22823"
MKDTIMG="${HOME}/android/lineage/prebuilts/misc/linux-x86/libufdt/mkdtimg"

# Generate dtboimg.cfg based on dtbo and dts fragments
function mk_dtboimg_cfg() {
    echo "file $1 out $2"

    echo $1.dtbo >>$2
    dts_file=$1.dts
    dtsino=`grep -m 1 'oplus_boardid,dtsino' $dts_file | sed 's/ //g' | sed 's/.*oplus_boardid\,dtsino\=\"//g' | sed 's/\"\;.*//g'`
    pcbmask=`grep -m 1 'oplus_boardid,pcbmask' $dts_file | sed 's/ //g' | sed 's/.*oplus_boardid\,pcbmask\=\"//g' | sed 's/\"\;.*//g'`

    echo " id=$my_dtbo_id" >> $2
    echo " custom0=$dtsino" >> $2
    echo " custom1=$pcbmask" >> $2
    let my_dtbo_id++
}

# Extract MediaTek dtbo certs from dtbo image
function extract_dtbo_certs() {
    rm -rf security
    mkdir security
    python extract_dtbo_certs.py dtbo.img
    mv cert1.bin security && mv cert2.bin security
}

# Generate and sign a custom dtbo image
function sign_dtbo() {
    echo -e "${colors[blue]}OPLUS DTBO SIGN:${colors[clear]} ${colors[yellow]}Extracting dtbo certs...${colors[clear]}"
    extract_dtbo_certs
    echo -e "${colors[blue]}OPLUS DTBO SIGN:${colors[clear]} ${colors[green]}Done${colors[clear]}\n"

    rm -rf dtboimg.cfg oplus_unsigned oplus_signed
    mkdir oplus_unsigned oplus_signed

    echo -e "${colors[blue]}OPLUS DTBO SIGN:${colors[clear]} ${colors[yellow]}Generating dtboimg.cfg...${colors[clear]}"
    for dtbo in $dtbo_support_list
    do
        echo " dtbo  $dtbo "
        mk_dtboimg_cfg ${dtbo} dtboimg.cfg
    done
    echo -e "${colors[blue]}OPLUS DTBO SIGN:${colors[clear]} ${colors[green]}Done${colors[clear]}\n"

    echo -e "${colors[blue]}OPLUS DTBO SIGN:${colors[clear]} ${colors[yellow]}Generating dtbo image...${colors[clear]}"
    ${MKDTIMG} cfg_create oplus_unsigned/dtbo.img dtboimg.cfg
    cp oplus_unsigned/dtbo.img oplus_signed/dtbo.img
    echo -e "${colors[blue]}OPLUS DTBO SIGN:${colors[clear]} ${colors[green]}Done${colors[clear]}\n"

    echo -e "${colors[blue]}OPLUS DTBO SIGN:${colors[clear]} ${colors[yellow]}Signing dtbo image...${colors[clear]}"
    echo -e "Running append_certs.py..."
    python append_certs.py --alignment 16 --cert1 security/cert1.bin --cert2 security/cert2.bin --dtbo oplus_signed/dtbo.img
    echo -e "${colors[blue]}OPLUS DTBO SIGN:${colors[clear]} ${colors[green]}Done${colors[clear]}\n"
}

# Main process
main() {
    sign_dtbo
}

main