From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 05/14] crc32: Miscellaneous cleanups
Date: Fri, 06 Jan 2012 21:51:15 -0800
Message-ID: <20120107055115.31315.19563.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120107055042.31315.63119.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Misc cleanup of lib/crc32.c and related files
	- removed unnecessary header files.
	- straightened out some convoluted ifdef's
	- rewrote some references to 2 dimensional arrays as 1 dimensional
	  arrays to make them correct. I.e. replaced tab[i] with tab[0][i].
	- a few trivial whitespace changes
	- fixed a warning in gen_crc32tables.c caused by a mismatch in the
	  type of the pointer passed to output table. Since the table is
	  only used at kernel compile time, it is simpler to make the table
	  big enough to hold the largest column size used. One cannot make the
	  column size smaller in output_table because it has to be used by
	  both the le and be tables and they can have different column sizes.

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c          |  104 +++++++++++++++++---------------------------------
 lib/gen_crc32table.c |    6 +--
 2 files changed, 39 insertions(+), 71 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index c93c9ae..2a87ea2 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -23,13 +23,10 @@
 /* see: Documentation/crc32.txt for a description of algorithms */
 
 #include <linux/crc32.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/compiler.h>
 #include <linux/types.h>
-#include <linux/init.h>
-#include <linux/atomic.h>
 #include "crc32defs.h"
+
 #if CRC_LE_BITS == 8
 # define tole(x) __constant_cpu_to_le32(x)
 #else
@@ -41,6 +38,7 @@
 #else
 # define tobe(x) (x)
 #endif
+
 #include "crc32table.h"
 
 MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
@@ -96,6 +94,7 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 #undef DO_CRC4
 }
 #endif
+
 /**
  * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
@@ -103,53 +102,39 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
-
-#if CRC_LE_BITS == 1
-/*
- * In fact, the table-based code will work in this case, but it can be
- * simplified by inlining the table in ?: form.
- */
-
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
+#if CRC_LE_BITS == 1
 	int i;
 	while (len--) {
 		crc ^= *p++;
 		for (i = 0; i < 8; i++)
 			crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
 	}
-	return crc;
-}
-#else				/* Table-based approach */
-
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
-{
-# if CRC_LE_BITS == 8
-	const u32      (*tab)[] = crc32table_le;
-
-	crc = __cpu_to_le32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	return __le32_to_cpu(crc);
-# elif CRC_LE_BITS == 4
+# elif CRC_LE_BITS == 2
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
-		crc = (crc >> 4) ^ crc32table_le[crc & 15];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
+		crc = (crc >> 2) ^ crc32table_le[0][crc & 3];
 	}
-	return crc;
-# elif CRC_LE_BITS == 2
+# elif CRC_LE_BITS == 4
 	while (len--) {
 		crc ^= *p++;
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
-		crc = (crc >> 2) ^ crc32table_le[crc & 3];
+		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
+		crc = (crc >> 4) ^ crc32table_le[0][crc & 15];
 	}
+# elif CRC_LE_BITS == 8
+	const u32      (*tab)[] = crc32table_le;
+
+	crc = __cpu_to_le32(crc);
+	crc = crc32_body(crc, p, len, tab);
+	crc = __le32_to_cpu(crc);
+#endif
 	return crc;
-# endif
 }
-#endif
+EXPORT_SYMBOL(crc32_le);
 
 /**
  * crc32_be() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
@@ -158,16 +143,9 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
-
-#if CRC_BE_BITS == 1
-/*
- * In fact, the table-based code will work in this case, but it can be
- * simplified by inlining the table in ?: form.
- */
-
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
+#if CRC_BE_BITS == 1
 	int i;
 	while (len--) {
 		crc ^= *p++ << 24;
@@ -176,39 +154,29 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 			    (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE :
 					  0);
 	}
-	return crc;
-}
-
-#else				/* Table-based approach */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
-{
-# if CRC_BE_BITS == 8
-	const u32      (*tab)[] = crc32table_be;
-
-	crc = __cpu_to_be32(crc);
-	crc = crc32_body(crc, p, len, tab);
-	return __be32_to_cpu(crc);
-# elif CRC_BE_BITS == 4
+# elif CRC_BE_BITS == 2
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
-		crc = (crc << 4) ^ crc32table_be[crc >> 28];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
+		crc = (crc << 2) ^ crc32table_be[0][crc >> 30];
 	}
-	return crc;
-# elif CRC_BE_BITS == 2
+# elif CRC_BE_BITS == 4
 	while (len--) {
 		crc ^= *p++ << 24;
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
-		crc = (crc << 2) ^ crc32table_be[crc >> 30];
+		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
+		crc = (crc << 4) ^ crc32table_be[0][crc >> 28];
 	}
-	return crc;
+# elif CRC_BE_BITS == 8
+	const u32      (*tab)[] = crc32table_be;
+
+	crc = __cpu_to_be32(crc);
+	crc = crc32_body(crc, p, len, tab);
+	crc = __be32_to_cpu(crc);
 # endif
+	return crc;
 }
-#endif
-
-EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(crc32_be);
 
 #ifdef CONFIG_CRC32_SELFTEST
diff --git a/lib/gen_crc32table.c b/lib/gen_crc32table.c
index 85d0e41..eced769 100644
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -7,8 +7,8 @@
 #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
 #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
 
-static uint32_t crc32table_le[4][LE_TABLE_SIZE];
-static uint32_t crc32table_be[4][BE_TABLE_SIZE];
+static uint32_t crc32table_le[4][256];
+static uint32_t crc32table_be[4][256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -62,7 +62,7 @@ static void crc32init_be(void)
 	}
 }
 
-static void output_table(uint32_t table[4][256], int len, char *trans)
+static void output_table(uint32_t (*table)[256], int len, char *trans)
 {
 	int i, j;
 
