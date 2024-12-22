import struct
import sys
import os

def grab_certs_from_dtbo(file_path):
    mtk_header_start = b"\x88\x16\x88\x58"

    try:
        # Open the dtbo.img file in binary read mode
        with open(file_path, 'rb') as file:
            data = file.read()

        # Search for all occurrences of the pattern in the file
        certs = []
        for i in range(len(data) - len(mtk_header_start)):
            match = True
            for j in range(len(mtk_header_start)):
                if mtk_header_start[j] != data[i + j]:
                    match = False
                    break
            if match:
                certs.append(i)

        if len(certs) < 2:
            print("Error: MTK headers not found")
            return

        # Extract cert1 and cert2
        cert1_offset = certs[0]
        cert2_offset = certs[1]

        print(f"Cert1 found at 0x{cert1_offset}")
        print(f"Cert2 found at 0x{cert2_offset}")

        # Save the certificates as separate files
        with open("cert1.bin", "wb") as cert1_file:
            cert1_file.write(data[cert1_offset:cert2_offset])

        with open("cert2.bin", "wb") as cert2_file:
            cert2_file.write(data[cert2_offset:])

        print("Certificates saved to cert1.bin and cert2.bin")

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {os.path.basename(sys.argv[0])} <dtbo.img>")
        sys.exit(1)

    file_path = sys.argv[1]
    grab_certs_from_dtbo(file_path)
