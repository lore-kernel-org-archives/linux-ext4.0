From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/37] libext2fs: Add crc32c implementation for metadata
	checksumming
Date: Wed, 31 Aug 2011 17:35:36 -0700
Message-ID: <20110901003536.1176.46176.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:43416 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab1IAAfo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:35:44 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810Rfrl024842
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:27:41 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810ZcnC194834
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:35:39 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VIZanF021902
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:35:37 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a slicing-by-8 CRC32c implementation for metadata checksumming.
Adapted from Bob Pearson's kernel patch.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/Makefile.in       |   15 +
 lib/ext2fs/crc32c.c          |  435 ++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/crc32c_defs.h     |   67 ++++++
 lib/ext2fs/ext2fs.h          |    4 
 lib/ext2fs/gen_crc32ctable.c |  123 ++++++++++++
 5 files changed, 644 insertions(+), 0 deletions(-)
 create mode 100644 lib/ext2fs/crc32c.c
 create mode 100644 lib/ext2fs/crc32c_defs.h
 create mode 100644 lib/ext2fs/gen_crc32ctable.c


diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index f6338f0..f05cba8 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -33,6 +33,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	check_desc.o \
 	closefs.o \
 	crc16.o \
+	crc32c.o \
 	csum.o \
 	dblist.o \
 	dblist_dir.o \
@@ -99,6 +100,8 @@ SRCS= ext2_err.c \
 	$(srcdir)/check_desc.c \
 	$(srcdir)/closefs.c \
 	$(srcdir)/crc16.c \
+	$(srcdir)/crc32c.c \
+	$(srcdir)/gen_crc32ctable.c \
 	$(srcdir)/csum.c \
 	$(srcdir)/dblist.c \
 	$(srcdir)/dblist_dir.c \
@@ -393,6 +396,15 @@ $(top_builddir)/lib/ext2fs/ext2_err.h: ext2_err.h
 
 $(OBJS): subdirs
 
+gen_crc32ctable: $(srcdir)/gen_crc32ctable.c
+	$(E) "	CC $@"
+	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32ctable \
+		$(srcdir)/gen_crc32ctable.c
+
+crc32c_table.h: gen_crc32ctable
+	$(E) "	GEN32CTABLE $@"
+	$(Q) ./gen_crc32ctable > crc32c_table.h
+
 # +++ Dependency line eater +++
 # 
 # Makefile dependencies follow.  This must be the last section in
@@ -476,6 +488,9 @@ closefs.o: $(srcdir)/closefs.c $(srcdir)/ext2_fs.h \
  $(srcdir)/bitops.h
 crc16.o: $(srcdir)/crc16.c $(top_builddir)/lib/ext2fs/ext2_types.h \
  $(srcdir)/crc16.h
+crc32c.o: $(srcdir)/crc32c.c $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(srcdir)/crc32c_table.h $(srcdir)/crc32c_defs.h
+gen_crc32ctable.o: $(srcdir)/gen_crc32ctable.c $(srcdir)/crc32c_defs.h
 csum.o: $(srcdir)/csum.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
new file mode 100644
index 0000000..229bd37
--- /dev/null
+++ b/lib/ext2fs/crc32c.c
@@ -0,0 +1,435 @@
+/*
+ * crc32c.c
+ *
+ * August 26, 2011 Darrick J. Wong <djwong at us.ibm.com>
+ * Reuse Bob Pearson's slice-by-8 implementation for e2fsprogs.
+ *
+ * July 20, 2011 Bob Pearson <rpearson at systemfabricworks.com>
+ * added slice by 8 algorithm to the existing conventional and
+ * slice by 4 algorithms.
+ *
+ * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
+ * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
+ * Code was from the public domain, copyright abandoned.  Code was
+ * subsequently included in the kernel, thus was re-licensed under the
+ * GNU GPL v2.
+ *
+ * Oct 12, 2000 Matt Domsch <Matt_Domsch@dell.com>
+ * Same crc32 function was used in 5 other places in the kernel.
+ * I made one version, and deleted the others.
+ * There are various incantations of crc32().  Some use a seed of 0 or ~0.
+ * Some xor at the end with ~0.  The generic crc32() function takes
+ * seed as an argument, and doesn't xor at the end.  Then individual
+ * users can do whatever they need.
+ *   drivers/net/smc9194.c uses seed ~0, doesn't xor with ~0.
+ *   fs/jffs2 uses seed 0, doesn't xor with ~0.
+ *   fs/partitions/efi.c uses seed ~0, xor's with ~0.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+#include <stdint.h>
+#include <endian.h>
+#include <stdlib.h>
+#define __force
+#define min(x, y)		((x) > (y) ? (y) : (x))
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+#define __ALIGN_KERNEL(x, a)	__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
+#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
+#include "crc32c_defs.h"
+
+#if CRC_LE_BITS > 8
+# define tole(x) (__force uint32_t) __constant_cpu_to_le32(x)
+#else
+# define tole(x) (x)
+#endif
+
+#if CRC_BE_BITS > 8
+# define tobe(x) (__force uint32_t) __constant_cpu_to_be32(x)
+#else
+# define tobe(x) (x)
+#endif
+
+#include "crc32c_table.h"
+
+#if CRC_LE_BITS == 32
+/* slice by 4 algorithm */
+static uint32_t crc32c_le_body(uint32_t crc, uint8_t const *buf, size_t len)
+{
+	const uint8_t *p8;
+	const uint32_t *p32;
+	size_t init_bytes;
+	size_t words;
+	size_t end_bytes;
+	size_t i;
+	uint32_t q;
+	uint8_t i0, i1, i2, i3;
+
+	crc = (__force uint32_t) __cpu_to_le32(crc);
+
+	/* unroll loop into 'init_bytes' odd bytes followed by
+	 * 'words' aligned 4 byte words followed by
+	 * 'end_bytes' odd bytes at the end */
+	p8 = buf;
+	p32 = (uint32_t *)PTR_ALIGN(p8, 4);
+	init_bytes = min((uintptr_t)p32 - (uintptr_t)p8, len);
+	words = (len - init_bytes) >> 2;
+	end_bytes = (len - init_bytes) & 3;
+
+	for (i = 0; i < init_bytes; i++) {
+#ifndef WORDS_BIGENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_le[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_le[i0] ^ (crc << 8);
+#endif
+	}
+
+	/* using pre-increment below slightly faster */
+	p32--;
+
+	for (i = 0; i < words; i++) {
+#ifndef WORDS_BIGENDIAN
+		q = *++p32 ^ crc;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc = t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^ t0_le[i0];
+#else
+		q = *++p32 ^ crc;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc = t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^ t0_le[i0];
+#endif
+	}
+
+	p8 = (uint8_t *)(++p32);
+
+	for (i = 0; i < end_bytes; i++) {
+#ifndef WORDS_BIGENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_le[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_le[i0] ^ (crc << 8);
+#endif
+	}
+
+	return __le32_to_cpu((__force __le32)crc);
+}
+#endif
+
+#if CRC_BE_BITS == 32
+static uint32_t crc32c_be_body(uint32_t crc, uint8_t const *buf, size_t len)
+{
+	const uint8_t *p8;
+	const uint32_t *p32;
+	size_t init_bytes;
+	size_t words;
+	size_t end_bytes;
+	size_t i;
+	uint32_t q;
+	uint8_t i0, i1, i2, i3;
+
+	crc = (__force uint32_t) __cpu_to_be32(crc);
+
+	p8 = buf;
+	p32 = (uint32_t *)PTR_ALIGN(p8, 4);
+	init_bytes = min((uintptr_t)p32 - (uintptr_t)p8, len);
+	words = (len - init_bytes) >> 2;
+	end_bytes = (len - init_bytes) & 3;
+
+	for (i = 0; i < init_bytes; i++) {
+#ifndef WORDS_BIGENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_be[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_be[i0] ^ (crc << 8);
+#endif
+	}
+
+	p32--;
+
+	for (i = 0; i < words; i++) {
+#ifndef WORDS_BIGENDIAN
+		q = *++p32 ^ crc;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc = t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];
+#else
+		q = *++p32 ^ crc;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc = t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];
+#endif
+	}
+
+	p8 = (uint8_t *)(++p32);
+
+	for (i = 0; i < end_bytes; i++) {
+#ifndef WORDS_BIGENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_be[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_be[i0] ^ (crc << 8);
+#endif
+	}
+
+	return __be32_to_cpu((__force __be32)crc);
+}
+#endif
+
+#if CRC_LE_BITS == 64
+/* slice by 8 algorithm */
+static uint32_t crc32c_le_body(uint32_t crc, uint8_t const *buf, size_t len)
+{
+	const uint8_t *p8;
+	const uint32_t *p32;
+	size_t init_bytes;
+	size_t words;
+	size_t end_bytes;
+	size_t i;
+	uint32_t q;
+	uint8_t i0, i1, i2, i3;
+
+	crc = (__force uint32_t) __cpu_to_le32(crc);
+
+	p8 = buf;
+	p32 = (uint32_t *)PTR_ALIGN(p8, 8);
+	init_bytes = min((uintptr_t)p32 - (uintptr_t)p8, len);
+	words = (len - init_bytes) >> 3;
+	end_bytes = (len - init_bytes) & 7;
+
+	for (i = 0; i < init_bytes; i++) {
+#ifndef WORDS_BIGENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_le[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_le[i0] ^ (crc << 8);
+#endif
+	}
+
+	p32--;
+
+	for (i = 0; i < words; i++) {
+#ifndef WORDS_BIGENDIAN
+		q = *++p32 ^ crc;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc = t7_le[i3] ^ t6_le[i2] ^ t5_le[i1] ^ t4_le[i0];
+
+		q = *++p32;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc ^= t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^ t0_le[i0];
+#else
+		q = *++p32 ^ crc;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc = t7_le[i3] ^ t6_le[i2] ^ t5_le[i1] ^ t4_le[i0];
+
+		q = *++p32;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc ^= t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^ t0_le[i0];
+#endif
+	}
+
+	p8 = (uint8_t *)(++p32);
+
+	for (i = 0; i < end_bytes; i++) {
+#ifndef WORDS_BIGENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_le[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_le[i0] ^ (crc << 8);
+#endif
+	}
+
+	return __le32_to_cpu(crc);
+}
+#endif
+
+#if CRC_BE_BITS == 64
+static uint32_t crc32c_be_body(uint32_t crc, uint8_t const *buf, size_t len)
+{
+	const uint8_t *p8;
+	const uint32_t *p32;
+	size_t init_bytes;
+	size_t words;
+	size_t end_bytes;
+	size_t i;
+	uint32_t q;
+	uint8_t i0, i1, i2, i3;
+
+	crc = (__force uint32_t) __cpu_to_be32(crc);
+
+	p8 = buf;
+	p32 = (uint32_t *)PTR_ALIGN(p8, 8);
+	init_bytes = min((uintptr_t)p32 - (uintptr_t)p8, len);
+	words = (len - init_bytes) >> 3;
+	end_bytes = (len - init_bytes) & 7;
+
+	for (i = 0; i < init_bytes; i++) {
+#ifndef WORDS_BIGENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_be[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_be[i0] ^ (crc << 8);
+#endif
+	}
+
+	p32--;
+
+	for (i = 0; i < words; i++) {
+#ifndef WORDS_BIGENDIAN
+		q = *++p32 ^ crc;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc = t7_be[i3] ^ t6_be[i2] ^ t5_be[i1] ^ t4_be[i0];
+
+		q = *++p32;
+		i3 = q;
+		i2 = q >> 8;
+		i1 = q >> 16;
+		i0 = q >> 24;
+		crc ^= t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];
+#else
+		q = *++p32 ^ crc;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc = t7_be[i3] ^ t6_be[i2] ^ t5_be[i1] ^ t4_be[i0];
+
+		q = *++p32;
+		i3 = q >> 24;
+		i2 = q >> 16;
+		i1 = q >> 8;
+		i0 = q;
+		crc ^= t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];
+#endif
+	}
+
+	p8 = (uint8_t *)(++p32);
+
+	for (i = 0; i < end_bytes; i++) {
+#ifndef WORDS_BIGENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_be[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_be[i0] ^ (crc << 8);
+#endif
+	}
+
+	return __be32_to_cpu(crc);
+}
+#endif
+
+/**
+ * crc32c_le() - Calculate bitwise little-endian CRC32c.
+ * @crc: seed value for computation.  ~0 for ext4, sometimes 0 for
+ *	other uses, or the previous crc32c value if computing incrementally.
+ * @p: pointer to buffer over which CRC is run
+ * @len: length of buffer @p
+ */
+uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len)
+{
+#if CRC_LE_BITS == 1
+	int i;
+	while (len--) {
+		crc ^= *p++;
+		for (i = 0; i < 8; i++)
+			crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
+	}
+# elif CRC_LE_BITS == 2
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+	}
+# elif CRC_LE_BITS == 4
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 4) ^ t0_le[crc & 0x0f];
+		crc = (crc >> 4) ^ t0_le[crc & 0x0f];
+	}
+# elif CRC_LE_BITS == 8
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 8) ^ t0_le[crc & 0xff];
+	}
+# else
+	crc = crc32c_le_body(crc, p, len);
+# endif
+	return crc;
+}
+
+/**
+ * crc32c_be() - Calculate bitwise big-endian CRC32c.
+ * @crc: seed value for computation.  ~0 for ext4, sometimes 0 for
+ *	other uses, or the previous crc32c value if computing incrementally.
+ * @p: pointer to buffer over which CRC is run
+ * @len: length of buffer @p
+ */
+uint32_t crc32c_be(uint32_t crc, unsigned char const *p, size_t len)
+{
+#if CRC_BE_BITS == 1
+	int i;
+	while (len--) {
+		crc ^= *p++ << 24;
+		for (i = 0; i < 8; i++)
+			crc = (crc << 1) ^
+			      ((crc & 0x80000000) ? CRCPOLY_BE : 0);
+	}
+# elif CRC_BE_BITS == 2
+	while (len--) {
+		crc ^= *p++ << 24;
+		crc = (crc << 2) ^ t0_be[crc >> 30];
+		crc = (crc << 2) ^ t0_be[crc >> 30];
+		crc = (crc << 2) ^ t0_be[crc >> 30];
+		crc = (crc << 2) ^ t0_be[crc >> 30];
+	}
+# elif CRC_BE_BITS == 4
+	while (len--) {
+		crc ^= *p++ << 24;
+		crc = (crc << 4) ^ t0_be[crc >> 28];
+		crc = (crc << 4) ^ t0_be[crc >> 28];
+	}
+# elif CRC_BE_BITS == 8
+	while (len--) {
+		crc ^= *p++ << 24;
+		crc = (crc << 8) ^ t0_be[crc >> 24];
+	}
+# else
+	crc = crc32c_be_body(crc, p, len);
+# endif
+	return crc;
+}
diff --git a/lib/ext2fs/crc32c_defs.h b/lib/ext2fs/crc32c_defs.h
new file mode 100644
index 0000000..1752970
--- /dev/null
+++ b/lib/ext2fs/crc32c_defs.h
@@ -0,0 +1,67 @@
+/*
+ * This is the CRC32c polynomial, as outlined by Castagnoli.
+ * x^32+x^28+x^27+x^26+x^25+x^23+x^22+x^20+x^19+x^18+x^14+x^13+x^11+x^10+x^9+
+ * x^8+x^6+x^0
+ */
+#define CRCPOLY_LE 0x82F63B78
+#define CRCPOLY_BE 0x1EDC6F41
+
+/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64. */
+/* For less performance-sensitive, use 4 */
+#ifndef CRC_LE_BITS
+# define CRC_LE_BITS 64
+#endif
+#ifndef CRC_BE_BITS
+# define CRC_BE_BITS 64
+#endif
+
+/*
+ * Little-endian CRC computation.  Used with serial bit streams sent
+ * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
+ */
+#if CRC_LE_BITS > 64 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
+	CRC_LE_BITS & CRC_LE_BITS-1
+# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32, 64}"
+#endif
+
+/*
+ * Big-endian CRC computation.  Used with serial bit streams sent
+ * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
+ */
+#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
+	CRC_BE_BITS & CRC_BE_BITS-1
+# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
+#endif
+
+
+#define ___constant_swab32(x) \
+	((uint32_t)( \
+		(((uint32_t)(x) & (uint32_t)0x000000ffUL) << 24) | \
+		(((uint32_t)(x) & (uint32_t)0x0000ff00UL) <<  8) | \
+		(((uint32_t)(x) & (uint32_t)0x00ff0000UL) >>  8) | \
+		(((uint32_t)(x) & (uint32_t)0xff000000UL) >> 24)))
+
+
+#ifdef WORDS_BIGENDIAN
+#define __constant_cpu_to_le32(x) ___constant_swab32((x))
+#define __constant_cpu_to_be32(x) (x)
+#define __be32_to_cpu(x) (x)
+#define __cpu_to_be32(x) (x)
+#define __cpu_to_le32(x) (htole32((x)))
+#define __le32_to_cpu(x) (le32toh((x)))
+#else
+#define __constant_cpu_to_le32(x) (x)
+#define __constant_cpu_to_be32(x) ___constant_swab32((x))
+#define __be32_to_cpu(x) (be32toh((x)))
+#define __cpu_to_be32(x) (htobe32((x)))
+#define __cpu_to_le32(x) (x)
+#define __le32_to_cpu(x) (x)
+#endif
+
+#if (__GNUC__ >= 3)
+#define likely(x)	__builtin_expect(!!(x), 1)
+#define unlikely(x)	__builtin_expect(!!(x), 0)
+#else
+#define likely(x)	(x)
+#define unlikely(x)	(x)
+#endif
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e638169..e571508 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -887,6 +887,10 @@ extern int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 				    int *ret_meta_bg);
 extern void ext2fs_update_dynamic_rev(ext2_filsys fs);
 
+/* crc32c.c */
+extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
+extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
+
 /* csum.c */
 extern void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group);
 extern int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group);
diff --git a/lib/ext2fs/gen_crc32ctable.c b/lib/ext2fs/gen_crc32ctable.c
new file mode 100644
index 0000000..9996e9d
--- /dev/null
+++ b/lib/ext2fs/gen_crc32ctable.c
@@ -0,0 +1,123 @@
+#include <stdio.h>
+#include "crc32c_defs.h"
+#include <inttypes.h>
+
+#define ENTRIES_PER_LINE 4
+
+#if CRC_LE_BITS <= 8
+#define LE_TABLE_SIZE (1 << CRC_LE_BITS)
+#else
+#define LE_TABLE_SIZE 256
+#endif
+
+#if CRC_BE_BITS <= 8
+#define BE_TABLE_SIZE (1 << CRC_BE_BITS)
+#else
+#define BE_TABLE_SIZE 256
+#endif
+
+static uint32_t crc32ctable_le[8][256];
+static uint32_t crc32ctable_be[8][256];
+
+/**
+ * crc32cinit_le() - allocate and initialize LE table data
+ *
+ * crc is the crc of the byte i; other entries are filled in based on the
+ * fact that crctable[i^j] = crctable[i] ^ crctable[j].
+ *
+ */
+static void crc32cinit_le(void)
+{
+	unsigned i, j;
+	uint32_t crc = 1;
+
+	crc32ctable_le[0][0] = 0;
+
+	for (i = LE_TABLE_SIZE >> 1; i; i >>= 1) {
+		crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
+		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
+			crc32ctable_le[0][i + j] = crc ^ crc32ctable_le[0][j];
+	}
+	for (i = 0; i < LE_TABLE_SIZE; i++) {
+		crc = crc32ctable_le[0][i];
+		for (j = 1; j < 8; j++) {
+			crc = crc32ctable_le[0][crc & 0xff] ^ (crc >> 8);
+			crc32ctable_le[j][i] = crc;
+		}
+	}
+}
+
+/**
+ * crc32cinit_be() - allocate and initialize BE table data
+ */
+static void crc32cinit_be(void)
+{
+	unsigned i, j;
+	uint32_t crc = 0x80000000;
+
+	crc32ctable_be[0][0] = 0;
+
+	for (i = 1; i < BE_TABLE_SIZE; i <<= 1) {
+		crc = (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE : 0);
+		for (j = 0; j < i; j++)
+			crc32ctable_be[0][i + j] = crc ^ crc32ctable_be[0][j];
+	}
+	for (i = 0; i < BE_TABLE_SIZE; i++) {
+		crc = crc32ctable_be[0][i];
+		for (j = 1; j < 8; j++) {
+			crc = crc32ctable_be[0][(crc >> 24) & 0xff] ^
+			      (crc << 8);
+			crc32ctable_be[j][i] = crc;
+		}
+	}
+}
+
+static void output_table(uint32_t table[8][256], int len, char trans)
+{
+	int i, j;
+
+	for (j = 0 ; j < 8; j++) {
+		printf("static const uint32_t t%d_%ce[] = {", j, trans);
+		for (i = 0; i < len - 1; i++) {
+			if ((i % ENTRIES_PER_LINE) == 0)
+				printf("\n");
+			printf("to%ce(0x%8.8xL),", trans, table[j][i]);
+			if ((i % ENTRIES_PER_LINE) != (ENTRIES_PER_LINE - 1))
+				printf(" ");
+		}
+		printf("to%ce(0x%8.8xL)};\n\n", trans, table[j][len - 1]);
+
+		if (trans == 'l') {
+			if ((j+1)*8 >= CRC_LE_BITS)
+				break;
+		} else {
+			if ((j+1)*8 >= CRC_BE_BITS)
+				break;
+		}
+	}
+}
+
+int main(int argc, char **argv)
+{
+	printf("/*\n");
+	printf(" * crc32ctable.h - CRC32c tables\n");
+	printf(" *    this file is generated - do not edit\n");
+	printf(" *	# gen_crc32ctable > crc32c_table.h\n");
+	printf(" *    with\n");
+	printf(" *	CRC_LE_BITS = %d\n", CRC_LE_BITS);
+	printf(" *	CRC_BE_BITS = %d\n", CRC_BE_BITS);
+	printf(" */\n");
+	printf("#include <stdint.h>\n");
+
+	if (CRC_LE_BITS > 1) {
+		crc32cinit_le();
+		output_table(crc32ctable_le, LE_TABLE_SIZE, 'l');
+	}
+
+	if (CRC_BE_BITS > 1) {
+		crc32cinit_be();
+		output_table(crc32ctable_be, BE_TABLE_SIZE, 'b');
+	}
+
+	return 0;
+}

