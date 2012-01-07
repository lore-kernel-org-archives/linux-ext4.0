From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/14] crc32: Add slice-by-8 algorithm to existing code
Date: Fri, 06 Jan 2012 21:51:34 -0800
Message-ID: <20120107055134.31315.82660.stgit@elm3c44.beaverton.ibm.com>
References: <20120107055042.31315.63119.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45062 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464Ab2AGFwA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 00:52:00 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 00:51:58 -0500
In-Reply-To: <20120107055042.31315.63119.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

add slicing-by-8 algorithm to the existing
slicing-by-4 algorithm. This consists of:
	- extend largest BITS size from 32 to 64
	- extend tables from tab[4][256] to up to tab[8][256]
	- Add code for inner loop.

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c          |   40 ++++++++++++++++++++++++++++------------
 lib/crc32defs.h      |   29 +++++++++++++++++++++--------
 lib/gen_crc32table.c |   43 +++++++++++++++++++++++++++----------------
 3 files changed, 76 insertions(+), 36 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 157b35f..6311712 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -47,25 +47,28 @@ MODULE_LICENSE("GPL");
 
 #if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
 
+/* implements slicing-by-4 or slicing-by-8 algorithm */
 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
 #  define DO_CRC(x) (crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8))
-#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
-			t2[(crc >> 8) & 255] ^ \
-			t1[(crc >> 16) & 255] ^ \
-			t0[(crc >> 24) & 255]
+#  define DO_CRC4 (t3[(q) & 255] ^ t2[(q >> 8) & 255] ^ \
+		   t1[(q >> 16) & 255] ^ t0[(q >> 24) & 255])
+#  define DO_CRC8 (t7[(q) & 255] ^ t6[(q >> 8) & 255] ^ \
+		   t5[(q >> 16) & 255] ^ t4[(q >> 24) & 255])
 # else
 #  define DO_CRC(x) (crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8))
-#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
-			t1[(crc >> 8) & 255] ^ \
-			t2[(crc >> 16) & 255] ^ \
-			t3[(crc >> 24) & 255]
+#  define DO_CRC4 (t0[(q) & 255] ^ t1[(q >> 8) & 255] ^ \
+		   t2[(q >> 16) & 255] ^ t3[(q >> 24) & 255])
+#  define DO_CRC8 (t4[(q) & 255] ^ t5[(q >> 8) & 255] ^ \
+		   t6[(q >> 16) & 255] ^ t7[(q >> 24) & 255])
 # endif
 	const u32 *b;
-	size_t    rem_len;
+	size_t rem_len;
 	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
+	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
+	u32 q;
 
 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {
@@ -73,13 +76,25 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 			DO_CRC(*buf++);
 		} while ((--len) && ((long)buf)&3);
 	}
+
+# if CRC_LE_BITS == 32
 	rem_len = len & 3;
-	/* load data 32 bits wide, xor data 32 bits wide. */
 	len = len >> 2;
+# else
+	rem_len = len & 7;
+	len = len >> 3;
+# endif
+
 	b = (const u32 *)buf;
 	for (--b; len; --len) {
-		crc ^= *++b; /* use pre increment for speed */
-		DO_CRC4;
+		q = crc ^ *++b; /* use pre increment for speed */
+# if CRC_LE_BITS == 32
+		crc = DO_CRC4;
+# else
+		crc = DO_CRC8;
+		q = *++b;
+		crc ^= DO_CRC4;
+# endif
 	}
 	len = rem_len;
 	/* And the last few bytes */
@@ -92,6 +107,7 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 	return crc;
 #undef DO_CRC
 #undef DO_CRC4
+#undef DO_CRC8
 }
 #endif
 
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
index daa3a5e..8181592 100644
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -6,29 +6,42 @@
 #define CRCPOLY_LE 0xedb88320
 #define CRCPOLY_BE 0x04c11db7
 
-/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, and 32. */
-/* For less performance-sensitive, use 4 or 8 */
+/*
+ * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64.
+ * For less performance-sensitive, use 4 or 8 to save table size.
+ * For larger systems choose same as CPU architecture as default.
+ * This works well on X86_64, SPARC64 systems. This may require some
+ * elaboration after experiments with other architectures.
+ */
 #ifndef CRC_LE_BITS
-# define CRC_LE_BITS 32
+#  ifdef CONFIG_64BIT
+#  define CRC_LE_BITS 64
+#  else
+#  define CRC_LE_BITS 32
+#  endif
 #endif
 #ifndef CRC_BE_BITS
-# define CRC_BE_BITS 32
+#  ifdef CONFIG_64BIT
+#  define CRC_BE_BITS 64
+#  else
+#  define CRC_BE_BITS 32
+#  endif
 #endif
 
 /*
  * Little-endian CRC computation.  Used with serial bit streams sent
  * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
  */
-#if CRC_LE_BITS > 32 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
+#if CRC_LE_BITS > 64 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
 	CRC_LE_BITS & CRC_LE_BITS-1
-# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32}"
+# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
 
 /*
  * Big-endian CRC computation.  Used with serial bit streams sent
  * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
  */
-#if CRC_BE_BITS > 32 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
+#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
 	CRC_BE_BITS & CRC_BE_BITS-1
-# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32}"
+# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
 #endif
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index 99ac744..0d9edd1 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -1,23 +1,28 @@
 #include <stdio.h>
+#include "../include/generated/autoconf.h"
 #include "crc32defs.h"
 #include <inttypes.h>
 
 #define ENTRIES_PER_LINE 4
 
-#if CRC_LE_BITS <= 8
-#define LE_TABLE_SIZE (1 << CRC_LE_BITS)
+#if CRC_LE_BITS > 8
+# define LE_TABLE_ROWS (CRC_LE_BITS/8)
+# define LE_TABLE_SIZE 256
 #else
-#define LE_TABLE_SIZE 256
+# define LE_TABLE_ROWS 1
+# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #endif
 
-#if CRC_BE_BITS <= 8
-#define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#if CRC_BE_BITS > 8
+# define BE_TABLE_ROWS (CRC_BE_BITS/8)
+# define BE_TABLE_SIZE 256
 #else
-#define BE_TABLE_SIZE 256
+# define BE_TABLE_ROWS 1
+# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 #endif
 
-static uint32_t crc32table_le[4][256];
-static uint32_t crc32table_be[4][256];
+static uint32_t crc32table_le[LE_TABLE_ROWS][256];
+static uint32_t crc32table_be[BE_TABLE_ROWS][256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -40,7 +45,7 @@ static void crc32init_le(void)
 	}
 	for (i = 0; i < LE_TABLE_SIZE; i++) {
 		crc = crc32table_le[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < LE_TABLE_ROWS; j++) {
 			crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
 			crc32table_le[j][i] = crc;
 		}
@@ -64,18 +69,18 @@ static void crc32init_be(void)
 	}
 	for (i = 0; i < BE_TABLE_SIZE; i++) {
 		crc = crc32table_be[0][i];
-		for (j = 1; j < 4; j++) {
+		for (j = 1; j < BE_TABLE_ROWS; j++) {
 			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
 			crc32table_be[j][i] = crc;
 		}
 	}
 }
 
-static void output_table(uint32_t (*table)[256], int len, char *trans)
+static void output_table(uint32_t (*table)[256], int rows, int len, char *trans)
 {
 	int i, j;
 
-	for (j = 0 ; j < 4; j++) {
+	for (j = 0 ; j < rows; j++) {
 		printf("{");
 		for (i = 0; i < len - 1; i++) {
 			if (i % ENTRIES_PER_LINE == 0)
@@ -92,15 +97,21 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static const u32 crc32table_le[4][256] = {");
-		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
+		printf("static const u32 __cacheline_aligned "
+		       "crc32table_le[%d][%d] = {",
+		       LE_TABLE_ROWS, LE_TABLE_SIZE);
+		output_table(crc32table_le, LE_TABLE_ROWS,
+			     LE_TABLE_SIZE, "tole");
 		printf("};\n");
 	}
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static const u32 crc32table_be[4][256] = {");
-		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
+		printf("static const u32 __cacheline_aligned "
+		       "crc32table_be[%d][%d] = {",
+		       BE_TABLE_ROWS, BE_TABLE_SIZE);
+		output_table(crc32table_be, LE_TABLE_ROWS,
+			     BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}
 

