# OPlus dtbo signing tool for OPlus MediaTek devices

## Requirements

It requires multiples files to be able to run this tool.

1 - Edit **dtbo_support_list** variable to your needs.

2 - Copy all dtbo dts fragments (example: oplus6983_22823.dts) to the tool folder root.

3 - Copy all the compiled dtbo fragments (example: oplus6983_22823.dtbo) to the tool folder root.

4 - Copy the original dtbo.img from ColorOS/OxygenOS/realmeUI to the tool folder root.

## Usage
If you want to use this tools, simply use

    ./oplus_dtbo_sign.sh

inside this folder.

## Example

### Expected dtboimg.cfg output
```markdown
k6983v1_64.dtbo
 id=
 custom0=
 custom1=
oplus6983_21007.dtbo
 id=1
 custom0=21007
 custom1=0xffff
oplus6983_22021.dtbo
 id=2
 custom0=22021
 custom1=0xfffd
oplus6983_22021_EVB.dtbo
 id=3
 custom0=22021
 custom1=0x2
oplus6983_22921.dtbo
 id=4
 custom0=22921
 custom1=0xffff
oplus6983_22823.dtbo
 id=5
 custom0=22823
 custom1=0xffff
```

### Expected running output
```markdown
OPLUS DTBO SIGN: Extracting dtbo certs...
Cert1 found at 0x1080336
Cert2 found at 0x1082592
Certificates saved to cert1.bin and cert2.bin
OPLUS DTBO SIGN: Done

OPLUS DTBO SIGN: Generating dtboimg.cfg...
 dtbo  k6983v1_64
file k6983v1_64 out dtboimg.cfg
 dtbo  oplus6983_21007
file oplus6983_21007 out dtboimg.cfg
 dtbo  oplus6983_22021
file oplus6983_22021 out dtboimg.cfg
 dtbo  oplus6983_22021_EVB
file oplus6983_22021_EVB out dtboimg.cfg
 dtbo  oplus6983_22921
file oplus6983_22921 out dtboimg.cfg
 dtbo  oplus6983_22823
file oplus6983_22823 out dtboimg.cfg
OPLUS DTBO SIGN: Done

OPLUS DTBO SIGN: Generating dtbo image...
create image file: oplus_unsigned/dtbo.img...
Total 6 entries.
OPLUS DTBO SIGN: Done

OPLUS DTBO SIGN: Signing dtbo image...
Running append_certs.py...
OPLUS DTBO SIGN: Done
```

## License
This project is licensed under the GPL-3.0 License - see the [LICENSE](https://github.com/lineageos-on-vitamin/android_tools_oplus-dtbo-sign/tree/main/LICENSE) file for details.
