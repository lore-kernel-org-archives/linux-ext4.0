Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3745A37FF76;
	Fri,  8 May 2026 12:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778242572; cv=none; b=PbdMQJYvPaCP0TvQv8dHL/hJYKuNPltI1jXotDCOyZwaF4gbIKf2U6WbM1K3SH9NAxWE0HnvkUqpkOhEAinK5r7ZM3rKAZe5hEjEWZ9/bW9XKHyDv7HmVau8jg1OgSCAHNpR+J9+eEa0pfGWEDdF5hPF5svVnkjuw3Tyv3yZt+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778242572; c=relaxed/simple;
	bh=UcUtEoeFLQkTX+9bdpVthUhnxii8XmIfti4ngDriq2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxNxr6lX/6bw6qwM+S8k6yTkxvGLu/hYA9YRyMmCNB1ax4VioYQHTVoevqnVnS12IwYrBc4DhiupdNjP/R4tid0DEuagowuL44mWcK4CiYwQZLmHpHo3q4N6t5iQJiFSW809DD+52b3fjpzPwDa4jSRW845FMdJyYhJDRWDU3BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Sf2QXxMz; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Sf2QXxMz"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778242560; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zVCvkhkySoy4vLElucDPi/u0WE7sWUYB9QYlCMmSWqI=;
	b=Sf2QXxMzK1F2by5SdGfNtdPpAr9Gg8Q7kUg0hiWwkMwE1fwvLQqPX/KPXwb1rrrCSs9FYeVBiz6499ed8mqocA6XvUdprqJWYF57nFUYiJlzcd9vQ/I+gGMYVqZzhidnSEtX7X0SwsU7uMJv9P+SCijBC0R6BnLfofg3d9MnWXg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X2XQgnZ_1778242559;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X2XQgnZ_1778242559 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 08 May 2026 20:16:00 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	ebiggers@kernel.org,
	ardb@kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: [PATCH RFC 01/17] lib/crc: add crc32c_flip_range() for incremental CRC update
Date: Fri,  8 May 2026 20:15:23 +0800
Message-ID: <20260508121539.4174601-2-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
References: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a contiguous range of bits in a buffer is flipped, the CRC32c
checksum can be updated incrementally without re-scanning the entire
buffer, by exploiting the linearity of CRCs over GF(2):

  New_CRC = Old_CRC ^ CRC(flip_mask << trailing_bits)

Introduce crc32c_flip_range() which computes this delta using
precomputed GF(2) shift matrices and nibble-indexed lookup tables.
The implementation decomposes nbits and trailing_bits into
power-of-2 components and combines them via the CRC concatenation
property:

  CRC(A || B) = shift(CRC(A), len(B)) ^ CRC(B)

This gives O(log N) complexity with only ~9.8KB of static tables
(fits in L1 cache).  The current maximum supported buffer size is
64KB (INCR_MAX_ORDER = 19, i.e. 2^19 bits = 524288 bits = 64KB).

This is useful for filesystems like ext4, where bitmap updates
involve flipping a contiguous range of bits, and recalculating
the full CRC after every update is wasteful.

Benchmark results on Intel Xeon (Ice Lake) with CRC32c hardware
acceleration:

  bitmap:      1024  2048  4096  8192  16384  32768  65536
  flip(ns):      48    53    57    63     68     73     78
  full(ns):      45    88   182   357    709   1421   2853
  speedup:     0.9x  1.6x  3.1x  5.6x  10.3x  19.3x  36.3x

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 include/linux/crc32.h           |  25 ++++++
 lib/crc/.gitignore              |   2 +
 lib/crc/Makefile                |  13 ++-
 lib/crc/crc32c-incr.c           | 140 +++++++++++++++++++++++++++++++
 lib/crc/gen_crc32c_incr_table.c | 141 ++++++++++++++++++++++++++++++++
 5 files changed, 318 insertions(+), 3 deletions(-)
 create mode 100644 lib/crc/crc32c-incr.c
 create mode 100644 lib/crc/gen_crc32c_incr_table.c

diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index da78b215ff2e..034f73f0f5dc 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -81,6 +81,31 @@ u32 crc32_be(u32 crc, const void *p, size_t len);
  */
 u32 crc32c(u32 crc, const void *p, size_t len);
 
+/**
+ * crc32c_flip_range - Update CRC32c after flipping a range of bits
+ * @old_crc:    Existing CRC32c value of the buffer (pre-flip).
+ * @total_bits: Total size of the buffer in bits (e.g., 524288 for 64KB).
+ * @bit_off:    Starting bit offset of the modified range.
+ * @nbits:      Length of the flipped bit sequence.
+ *
+ * This function calculates the new CRC32c value when a contiguous range of
+ * bits is flipped (XORed with 1s) without re-scanning the entire buffer.
+ * It leverages the linearity of CRCs in Galois Field GF(2):
+ *
+ * New_CRC = Old_CRC ^ CRC(Mask_of_Ones << Trailing_Bits)
+ *
+ * The complexity is O(log nbits + log trailing_bits), making it
+ * significantly faster than recomputing the CRC for large buffers.
+ *
+ * Note: @total_bits must not exceed 524288 (2^19 bits = 64KB).  Callers
+ * must ensure that @bit_off + @nbits <= @total_bits.  Behavior is
+ * undefined if these constraints are violated.
+ *
+ * Return: The updated CRC32c value.
+ */
+u32 crc32c_flip_range(u32 old_crc, u32 total_bits,
+		      u32 bit_off, u32 nbits);
+
 /*
  * crc32_optimizations() returns flags that indicate which CRC32 library
  * functions are using architecture-specific optimizations.  Unlike
diff --git a/lib/crc/.gitignore b/lib/crc/.gitignore
index a9e48103c9fb..4e2b9524426d 100644
--- a/lib/crc/.gitignore
+++ b/lib/crc/.gitignore
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /crc32table.h
+/crc32c-incr-table.h
 /crc64table.h
 /gen_crc32table
+/gen_crc32c_incr_table
 /gen_crc64table
diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index ff213590e4e3..2c255ac029d0 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -21,7 +21,7 @@ crc-t10dif-$(CONFIG_X86) += x86/crc16-msb-pclmul.o
 endif
 
 obj-$(CONFIG_CRC32) += crc32.o
-crc32-y := crc32-main.o
+crc32-y := crc32-main.o crc32c-incr.o
 ifeq ($(CONFIG_CRC32_ARCH),y)
 CFLAGS_crc32-main.o += -I$(src)/$(SRCARCH)
 crc32-$(CONFIG_ARM) += arm/crc32-core.o
@@ -49,20 +49,27 @@ endif # CONFIG_CRC64_ARCH
 
 obj-y += tests/
 
-hostprogs := gen_crc32table gen_crc64table
-clean-files := crc32table.h crc64table.h
+hostprogs := gen_crc32table gen_crc32c_incr_table gen_crc64table
+clean-files := crc32table.h crc32c-incr-table.h crc64table.h
 
 $(obj)/crc32-main.o: $(obj)/crc32table.h
+$(obj)/crc32c-incr.o: $(obj)/crc32c-incr-table.h
 $(obj)/crc64-main.o: $(obj)/crc64table.h
 
 quiet_cmd_crc32 = GEN     $@
       cmd_crc32 = $< > $@
 
+quiet_cmd_crc32c_incr = GEN     $@
+      cmd_crc32c_incr = $< > $@
+
 quiet_cmd_crc64 = GEN     $@
       cmd_crc64 = $< > $@
 
 $(obj)/crc32table.h: $(obj)/gen_crc32table
 	$(call cmd,crc32)
 
+$(obj)/crc32c-incr-table.h: $(obj)/gen_crc32c_incr_table
+	$(call cmd,crc32c_incr)
+
 $(obj)/crc64table.h: $(obj)/gen_crc64table
 	$(call cmd,crc64)
diff --git a/lib/crc/crc32c-incr.c b/lib/crc/crc32c-incr.c
new file mode 100644
index 000000000000..b6258231cc0d
--- /dev/null
+++ b/lib/crc/crc32c-incr.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * GF(2) matrix-based CRC32c incremental update.
+ *
+ * When a contiguous range of bits is flipped, the new CRC can be
+ * derived from the old one without re-scanning the buffer:
+ *   New_CRC = Old_CRC ^ CRC(flip_mask << trailing_bits)
+ *
+ * The delta CRC is computed by decomposing num_bits and trailing_bits
+ * into power-of-2 components and combining them via the CRC
+ * concatenation property, giving O(log N) complexity.
+ *
+ * Memory usage: ~9.8KB
+ * - crc32c_incr_nibble_table: 19 * 8 * 16 * 4 = 9728 bytes
+ * - crc32c_incr_ones_lookup:  20 * 4          = 80   bytes
+ *
+ * Tables are generated at compile time by gen_crc32c_incr_table.
+ * INCR_MAX_ORDER 19 supports up to 64KB buffers (2^19 bits).
+ *
+ * Copyright (C) 2026 Alibaba Inc.
+ */
+
+#include <linux/bitops.h>
+#include <linux/bug.h>
+#include <linux/export.h>
+#include <linux/crc32.h>
+
+#include "crc32c-incr-table.h"
+
+#define INCR_MAX_ORDER		19
+
+/**
+ * gf2_xform - Multiply a CRC state vector by a GF(2) shift matrix
+ * @order: Selects the precomputed matrix M^(2^order).
+ * @v: The 32-bit CRC state vector.
+ *
+ * Computes v * M^(2^order) using nibble (4-bit) indexed tables,
+ * reducing the operation from 32 bit-level iterations to 8 lookups.
+ */
+static inline u32 gf2_xform(int order, u32 v)
+{
+	const u32 (*tab)[16] = crc32c_incr_nibble_table[order];
+
+	return tab[0][v & 0xf] ^
+	       tab[1][(v >> 4) & 0xf] ^
+	       tab[2][(v >> 8) & 0xf] ^
+	       tab[3][(v >> 12) & 0xf] ^
+	       tab[4][(v >> 16) & 0xf] ^
+	       tab[5][(v >> 20) & 0xf] ^
+	       tab[6][(v >> 24) & 0xf] ^
+	       tab[7][(v >> 28) & 0xf];
+}
+
+/**
+ * crc32c_incr_get_ones_delta - Compute CRC of an all-ones bit sequence
+ * @num_bits: Length of the all-ones sequence.
+ *
+ * Returns CRC(0, [111...1] of length num_bits).  Decomposes num_bits
+ * into powers of 2 (MSB-first) and combines using:
+ *   CRC(A || B) = shift(CRC(A), len(B)) ^ CRC(B)
+ *
+ * This requires only (popcount - 1) gf2_xform calls, each doing
+ * 8 table lookups.
+ *
+ * Caller must ensure num_bits <= (1UL << INCR_MAX_ORDER).
+ */
+static u32 crc32c_incr_get_ones_delta(size_t num_bits)
+{
+	u32 delta;
+	int n;
+
+	if (!num_bits)
+		return 0;
+
+	/* Initialize with the highest power-of-2 block */
+	n = __fls(num_bits);
+	delta = crc32c_incr_ones_lookup[n];
+	num_bits ^= (1UL << n);
+
+	/* Concatenate remaining blocks from high to low */
+	while (num_bits) {
+		n = __fls(num_bits);
+		delta = gf2_xform(n, delta);
+		delta ^= crc32c_incr_ones_lookup[n];
+		num_bits ^= (1UL << n);
+	}
+	return delta;
+}
+
+/**
+ * gf2_shift_crc - Shift a CRC state by @trailing_bits zero-bit positions
+ * @crc: The CRC state vector.
+ * @trailing_bits: Number of zero bits to shift through.
+ *
+ * Equivalent to appending @trailing_bits zero bits to the data stream
+ * and continuing the CRC computation.  Decomposes trailing_bits into
+ * powers of 2 and applies the corresponding precomputed matrices.
+ */
+static u32 gf2_shift_crc(u32 crc, size_t trailing_bits)
+{
+	int n;
+
+	for (n = 0; trailing_bits > 0 && n < INCR_MAX_ORDER; n++) {
+		if (trailing_bits & 1)
+			crc = gf2_xform(n, crc);
+		trailing_bits >>= 1;
+	}
+	return crc;
+}
+
+/* See full kernel-doc in include/linux/crc32.h */
+u32 crc32c_flip_range(u32 old_crc, u32 total_bits,
+		      u32 bit_off, u32 nbits)
+{
+	u32 delta, trailing_bits;
+
+	if (!nbits)
+		return old_crc;
+
+	/*
+	 * total_bits must not exceed 2^INCR_MAX_ORDER bits (64KB).
+	 * bit_off + nbits must not exceed total_bits.
+	 */
+	if (WARN_ON_ONCE(total_bits > (1UL << INCR_MAX_ORDER)))
+		return old_crc;
+	if (WARN_ON_ONCE(bit_off + nbits > total_bits))
+		return old_crc;
+
+	trailing_bits = total_bits - (bit_off + nbits);
+
+	/* 1. Calculate CRC of the flip-mask (all 1s of length nbits) */
+	delta = crc32c_incr_get_ones_delta(nbits);
+
+	/* 2. Shift the mask-CRC to the correct bit position */
+	delta = gf2_shift_crc(delta, trailing_bits);
+
+	/* 3. Apply the delta to the existing CRC */
+	return old_crc ^ delta;
+}
+EXPORT_SYMBOL(crc32c_flip_range);
diff --git a/lib/crc/gen_crc32c_incr_table.c b/lib/crc/gen_crc32c_incr_table.c
new file mode 100644
index 000000000000..f906506282cc
--- /dev/null
+++ b/lib/crc/gen_crc32c_incr_table.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generate GF(2) nibble-based lookup tables for incremental CRC32c updates.
+ * MAX_ORDER 19 supports up to 64KB buffers (2^19 bits = 524288 bits).
+ *
+ * Instead of storing raw 32x32 bit matrices (32 rows per order),
+ * we precompute nibble (4-bit) indexed tables.  This reduces gf2_xform
+ * to 8 table lookups instead of 32 branchless mask-and-XOR iterations.
+ *
+ * Memory layout:
+ * - crc32c_incr_nibble_table[19][8][16]: 19 * 8 * 16 * 4 = 9728 bytes
+ * - crc32c_incr_ones_lookup[20]:         20 * 4          = 80   bytes
+ * Total: ~9.8KB (fits comfortably in L1 cache)
+ *
+ * Copyright (C) 2026 Alibaba Inc.
+ */
+
+#include <stdio.h>
+#include <inttypes.h>
+
+#include "../../include/linux/crc32poly.h"
+
+#define CRC32C_INCR_MAX_ORDER	19
+#define NIBBLES_PER_U32		8
+
+static uint32_t bit_matrix[CRC32C_INCR_MAX_ORDER][32];
+static uint32_t nibble_table[CRC32C_INCR_MAX_ORDER][NIBBLES_PER_U32][16];
+static uint32_t ones_lookup[CRC32C_INCR_MAX_ORDER + 1];
+
+static void crc32c_incr_init(void)
+{
+	int n, i, k, v;
+
+	/*
+	 * Step 1: Build the order-0 matrix M, where M[i] is the CRC
+	 * state after shifting basis vector e_i by one bit position.
+	 */
+	for (i = 0; i < 32; i++) {
+		uint32_t r = 1U << i;
+
+		bit_matrix[0][i] = (r & 1) ?
+			(r >> 1) ^ CRC32C_POLY_LE : (r >> 1);
+	}
+
+	/* Step 2: M^(2^n) = (M^(2^(n-1)))^2 via matrix squaring */
+	for (n = 1; n < CRC32C_INCR_MAX_ORDER; n++) {
+		for (i = 0; i < 32; i++) {
+			uint32_t r = bit_matrix[n - 1][i];
+			uint32_t res = 0;
+
+			for (k = 0; k < 32; k++) {
+				if (r & (1U << k))
+					res ^= bit_matrix[n - 1][k];
+			}
+			bit_matrix[n][i] = res;
+		}
+	}
+
+	/* Step 3: Convert bit matrices to nibble-indexed lookup tables */
+	for (n = 0; n < CRC32C_INCR_MAX_ORDER; n++) {
+		for (i = 0; i < NIBBLES_PER_U32; i++) {
+			nibble_table[n][i][0] = 0;
+			for (v = 1; v < 16; v++) {
+				uint32_t res = 0;
+
+				for (k = 0; k < 4; k++) {
+					if (v & (1 << k))
+						res ^= bit_matrix[n][i * 4 + k];
+				}
+				nibble_table[n][i][v] = res;
+			}
+		}
+	}
+
+	/*
+	 * Step 4: ones_lookup[n] = CRC(0, all-ones of 2^n bits).
+	 * Uses CRC(A||B) = shift(CRC(A), len(B)) ^ CRC(B) to double
+	 * the length at each step.  ones_lookup[0] = CRC of a single
+	 * 1-bit, which equals the generator polynomial.
+	 */
+	ones_lookup[0] = CRC32C_POLY_LE;
+
+	for (n = 1; n <= CRC32C_INCR_MAX_ORDER; n++) {
+		uint32_t low = ones_lookup[n - 1];
+		uint32_t high = 0;
+
+		for (k = 0; k < 32; k++) {
+			if (low & (1U << k))
+				high ^= bit_matrix[n - 1][k];
+		}
+		ones_lookup[n] = low ^ high;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	int n, i, v;
+
+	crc32c_incr_init();
+
+	printf("/* this file is generated - do not edit */\n\n");
+
+	printf("static const u32 crc32c_incr_nibble_table[%d][%d][16] = {\n",
+	       CRC32C_INCR_MAX_ORDER, NIBBLES_PER_U32);
+	for (n = 0; n < CRC32C_INCR_MAX_ORDER; n++) {
+		printf("\t{\n");
+		for (i = 0; i < NIBBLES_PER_U32; i++) {
+			printf("\t\t{\n");
+			for (v = 0; v < 16; v += 4) {
+				printf("\t\t\t0x%08x, 0x%08x, 0x%08x, 0x%08x,\n",
+				       nibble_table[n][i][v],
+				       nibble_table[n][i][v + 1],
+				       nibble_table[n][i][v + 2],
+				       nibble_table[n][i][v + 3]);
+			}
+			printf("\t\t},\n");
+		}
+		printf("\t},\n");
+	}
+	printf("};\n\n");
+
+	printf("static const u32 crc32c_incr_ones_lookup[%d] = {\n",
+	       CRC32C_INCR_MAX_ORDER + 1);
+	for (n = 0; n <= CRC32C_INCR_MAX_ORDER; n += 4) {
+		int remaining = CRC32C_INCR_MAX_ORDER + 1 - n;
+
+		if (remaining >= 4) {
+			printf("\t0x%08x, 0x%08x, 0x%08x, 0x%08x,\n",
+			       ones_lookup[n], ones_lookup[n + 1],
+			       ones_lookup[n + 2], ones_lookup[n + 3]);
+		} else {
+			printf("\t");
+			for (i = 0; i < remaining; i++)
+				printf("0x%08x, ", ones_lookup[n + i]);
+			printf("\n");
+		}
+	}
+	printf("};\n");
+
+	return 0;
+}
-- 
2.43.7

