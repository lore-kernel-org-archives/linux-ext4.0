From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/14] crc32: Make CRC_*_BITS definition correspond to actual
	bit counts
Date: Fri, 06 Jan 2012 21:51:28 -0800
Message-ID: <20120107055128.31315.75016.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120107055042.31315.63119.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

crc32.c provides a choice of one of several algorithms for
computing the LSB and LSB versions of the CRC32 checksum
based on the parameters CRC_LE_BITS and CRC_BE_BITS. In the
original version the values 1, 2, 4 and 8 respectively selected
versions of the alrogithm that computed the crc 1, 2, 4 and 32
bits as a time. This patch series adds a new version that computes
the CRC 64 bits at a time. To make things easier to understand
the parameter has been reinterpreted to actually stand for the
number of bits processed in each step of the algorithm so that
the old value 8 has been replaced with the value 32. This also
allows us to add in a widely used crc algorithm that
computes the crc 8 bits at a time called the Sarwate algorithm.

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c          |   17 ++++++++++++++---
 lib/crc32defs.h      |   18 ++++++++++--------
 lib/gen_crc32table.c |   11 ++++++++++-
 3 files changed, 34 insertions(+), 12 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index ff6bb9a..157b35f 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -27,13 +27,13 @@
 #include <linux/types.h>
 #include "crc32defs.h"
 
-#if CRC_LE_BITS == 8
+#if CRC_LE_BITS > 8
 # define tole(x) (__force u32) __constant_cpu_to_le32(x)
 #else
 # define tole(x) (x)
 #endif
 
-#if CRC_BE_BITS == 8
+#if CRC_BE_BITS > 8
 # define tobe(x) (__force u32) __constant_cpu_to_be32(x)
 #else
 # define tobe(x) (x)
@@ -45,7 +45,7 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
 MODULE_DESCRIPTION("Ethernet CRC32 calculations");
 MODULE_LICENSE("GPL");
 
-#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
+#if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
 
 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
@@ -126,6 +126,12 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
 	}
 # elif CRC_LE_BITS == 8
+	/* aka Sarwate algorithm */
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 8) ^ crc32table_le[0][crc & 255];
+	}
+# else
 	const u32      (*tab)[] = crc32table_le;
 
 	crc = (__force u32) __cpu_to_le32(crc);
@@ -169,6 +175,11 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
 	}
 # elif CRC_BE_BITS == 8
+	while (len--) {
+		crc ^= *p++ << 24;
+		crc = (crc << 8) ^ crc32table_be[0][crc >> 24];
+	}
+# else
 	const u32      (*tab)[] = crc32table_be;
 
 	crc = (__force u32) __cpu_to_be32(crc);
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
index f5a5401..daa3a5e 100644
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -6,27 +6,29 @@
 #define CRCPOLY_LE 0xedb88320
 #define CRCPOLY_BE 0x04c11db7
 
-/* How many bits at a time to use.  Requires a table of 4<<CRC_xx_BITS bytes. */
-/* For less performance-sensitive, use 4 */
+/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, and 32. */
+/* For less performance-sensitive, use 4 or 8 */
 #ifndef CRC_LE_BITS
-# define CRC_LE_BITS 8
+# define CRC_LE_BITS 32
 #endif
 #ifndef CRC_BE_BITS
-# define CRC_BE_BITS 8
+# define CRC_BE_BITS 32
 #endif
 
 /*
  * Little-endian CRC computation.  Used with serial bit streams sent
  * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
  */
-#if CRC_LE_BITS > 8 || CRC_LE_BITS < 1 || CRC_LE_BITS & CRC_LE_BITS-1
-# error CRC_LE_BITS must be a power of 2 between 1 and 8
+#if CRC_LE_BITS > 32 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
+	CRC_LE_BITS & CRC_LE_BITS-1
+# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32}"
 #endif
 
 /*
  * Big-endian CRC computation.  Used with serial bit streams sent
  * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
  */
-#if CRC_BE_BITS > 8 || CRC_BE_BITS < 1 || CRC_BE_BITS & CRC_BE_BITS-1
-# error CRC_BE_BITS must be a power of 2 between 1 and 8
+#if CRC_BE_BITS > 32 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
+	CRC_BE_BITS & CRC_BE_BITS-1
+# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32}"
 #endif
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index eced769..99ac744 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -4,8 +4,17 @@
 
 #define ENTRIES_PER_LINE 4
 
+#if CRC_LE_BITS <= 8
 #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
+#else
+#define LE_TABLE_SIZE 256
+#endif
+
+#if CRC_BE_BITS <= 8
 #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#else
+#define BE_TABLE_SIZE 256
+#endif
 
 static uint32_t crc32table_le[4][256];
 static uint32_t crc32table_be[4][256];
@@ -24,7 +33,7 @@ static void crc32init_le(void)
 
 	crc32table_le[0][0] = 0;
 
-	for (i = 1 << (CRC_LE_BITS - 1); i; i >>= 1) {
+	for (i = LE_TABLE_SIZE >> 1; i; i >>= 1) {
 		crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
 			crc32table_le[0][i + j] = crc ^ crc32table_le[0][j];

