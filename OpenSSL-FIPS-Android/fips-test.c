/* 
   Sample application using FIPS mode OpenSSL.

   This application will qualify as FIPS 140-2 validated when built,
   installed, and utilized as described in the "OpenSSL FIPS 140-2
   Security Policy" manual.

   This program prints information relevant to FIPS fingerprint
   calculation for 32-bit programs.

   Contents licensed under the terms of the OpenSSL license
   http://www.openssl.org/source/license.html
*/

#include <stdio.h>
#include <string.h>
#include <openssl/evp.h>
#include <openssl/fips.h>

extern const void*          FIPS_text_start(),  *FIPS_text_end();
extern const unsigned char  FIPS_rodata_start[], FIPS_rodata_end[];

extern unsigned char        FIPS_signature[20];
extern unsigned int         FIPS_incore_fingerprint (unsigned char *, unsigned int);

static unsigned char        Calculated_signature[20];

int main(int argc, char *argv[])
{
  int ret = 1, mode = 0, len=0;
  unsigned int i = 0;

  /********************/

  const unsigned int p1 = (unsigned int)FIPS_rodata_start;
  const unsigned int p2 = (unsigned int)FIPS_rodata_end;

  printf(".rodata start: 0x%08x\n", p1);
  printf(".rodata end: 0x%08x\n", p2);

  /********************/

  const unsigned int p3 = (unsigned int)FIPS_text_start();
  const unsigned int p4 = (unsigned int)FIPS_text_end();

  printf(".text start: 0x%08x\n", p3);
  printf(".text end: 0x%08x\n", p4);

  /********************/

  printf("Embedded: ");
  for(i = 0; i < 20; ++i) {
    printf("%02x", FIPS_signature[i]);
  }
  printf("\n");

  /********************/

  len = FIPS_incore_fingerprint(Calculated_signature, sizeof(Calculated_signature));
  if (len < 0) {
    printf("Failed to calculate expected signature");
    exit(1);
  }

  printf("Calculated: ");
  for(i = 0; i < len && i < sizeof(Calculated_signature); ++i) {
    printf("%02x", Calculated_signature[i]);
  }
  printf("\n");

  /********************/

  mode = FIPS_mode();
  printf("FIPS mode: %d\n", mode);
 
  if (!mode) {
    printf("Attempting to enable FIPS mode\n");
    if(FIPS_mode_set(1)) {
      ret = 0;
      printf("FIPS mode enabled\n");
    }
    else {
      ERR_load_crypto_strings();
      ERR_print_errors_fp(stderr);
    }
  }
  return ret;
}
