From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v4] crc32c: Implement CRC32c with slicing-by-8 algorithm
Date: Fri, 30 Sep 2011 12:29:56 -0700
Message-ID: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The existing CRC32c implementation uses Sarwate's algorithm to calculate the
code one byte at a time.  Using a slicing-by-8 algorithm adapted from Bob
Pearson, we can process buffers 8 bytes at a time, for a substantial increase
in performance.

The motivation for this patchset is that I am working on adding full metadata
checksumming to ext4 and jbd2.  As far as performance impact of adding
checksumming goes, I see nearly no change with a standard mail server ffsb
simulation.  On a test that involves only metadata operations (file creation
and deletion, and fallocate/truncate), I see a drop of about 50 pcercent with
the current kernel crc32c implementation; this improves to a drop of about 20
percent with the enclosed crc32c code.

When metadata is usually a small fraction of total IO, this new implementation
doesn't help much because metadata is usually a small fraction of total IO.
However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
tree), then this patch speeds up the operation substantially.

Given that iscsi, sctp, and btrfs also use crc32c, this patchset should improve
their speed as well.  I have some preliminary results[1] that show the
difference in various crc algorithms that I've come across: the "crc32c-by8-le"
column is the new algorithm in the patch; the "crc32c" column is the current
crc32c kernel implementation; and the "crc32-kern-le" column is the current
crc32 kernel implementation, which is similar to the results one gets for
CONFIG_CRC32C_SLICEBY4=y.  As you can see, the new implementation runs at
nearly 4x the speed of the current implementation; even the slimmer slice-by-4
implementation is generally 2-3x faster.

However, the implementation allows the kernel builder to select from a variety
of space-speed tradeoffs, should my results not hold true on a particular
class of system.

v2: Use the crypto testmgr api for self-test.
v3: Get rid of the -be version, which had no users.
v4: Allow kernel builder a choice of speed vs. space optimization.

[1]http://djwong.org/docs/ext4_metadata_checksums.html
(cached copy of the ext4 wiki)

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 crypto/Kconfig           |   36 +++++
 crypto/Makefile          |   11 ++
 crypto/crc32c.c          |  305 ++++++++++++++++++++++++++++++++++------------
 crypto/crc32c_defs.h     |   39 ++++++
 crypto/gen_crc32ctable.c |   79 ++++++++++++
 5 files changed, 389 insertions(+), 81 deletions(-)
 create mode 100644 crypto/crc32c_defs.h
 create mode 100644 crypto/gen_crc32ctable.c


diff --git a/crypto/Kconfig b/crypto/Kconfig
index ae27b75..3fb6dc8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -307,6 +307,42 @@ config CRYPTO_CRC32C
 	  by iSCSI for header and data digests and by others.
 	  See Castagnoli93.  Module will be crc32c.
 
+if CRYPTO_CRC32C
+choice
+	prompt "CRC32C variant"
+	default CRC32C_SLICEBY8
+
+config CRC32C_SLICEBY8
+	bool "Slice by 8 bytes"
+	---help---
+	  Calculate checksum 8 bytes at a time with a clever slicing algorithm.
+	  This is the fastest algorithm, but comes with a 8KiB lookup table.
+	  Most modern processors have sufficient cache that this shouldn't be
+	  a huge problem.
+
+	  If you don't know which to choose, choose this one.
+
+config CRC32C_SLICEBY4
+	bool "Slice by 4 bytes"
+	---help---
+	  Calculate checksum 8 bytes at a time with a clever slicing algorithm.
+	  This is reasonably fast, but has a 4KiB lookup table.
+
+config CRC32C_SARWATE
+	bool "Sarwate's Algorithm (one byte at a time)"
+	---help---
+	  Calculate checksum a byte at a time using Sarwate's algorithm.  This
+	  is not very fast, but has a svelte 256 byte lookup table.
+
+config CRC32C_BIT
+	bool "Classic Algorithm (one bit at a time)"
+	---help---
+	  Calculate checksum one bit at a time.  This is VERY slow, but has
+	  no lookup table.  This is provided as a debugging option.
+
+endchoice
+endif
+
 config CRYPTO_CRC32C_INTEL
 	tristate "CRC32c INTEL hardware acceleration"
 	depends on X86
diff --git a/crypto/Makefile b/crypto/Makefile
index ce5a813..00811ef 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -94,3 +94,14 @@ obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 #
 obj-$(CONFIG_XOR_BLOCKS) += xor.o
 obj-$(CONFIG_ASYNC_CORE) += async_tx/
+
+hostprogs-y	:= gen_crc32ctable
+clean-files	:= crc32ctable.h
+
+$(obj)/crc32c.o: $(obj)/crc32c_table.h
+
+quiet_cmd_crc32c = GEN     $@
+      cmd_crc32c = $< > $@
+
+$(obj)/crc32c_table.h: $(obj)/gen_crc32ctable
+	$(call cmd,crc32c)
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 3f9ad28..d510ec8 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -33,6 +33,35 @@
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
+ * The current crc32c implementation is adapted from Bob Pearson's slice-by-8
+ * crc32 kernel patch from mid-2011.
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
  */
 
 #include <crypto/internal/hash.h>
@@ -40,6 +69,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include "crc32c_defs.h"
 
 #define CHKSUM_BLOCK_SIZE	1
 #define CHKSUM_DIGEST_SIZE	4
@@ -52,92 +82,205 @@ struct chksum_desc_ctx {
 	u32 crc;
 };
 
-/*
- * This is the CRC-32C table
- * Generated with:
- * width = 32 bits
- * poly = 0x1EDC6F41
- * reflect input bytes = true
- * reflect output bytes = true
- */
+#if CRC32C_BITS > 8
+# define tole(x) (__force u32) __constant_cpu_to_le32(x)
+#else
+# define tole(x) (x)
+#endif
 
-static const u32 crc32c_table[256] = {
-	0x00000000L, 0xF26B8303L, 0xE13B70F7L, 0x1350F3F4L,
-	0xC79A971FL, 0x35F1141CL, 0x26A1E7E8L, 0xD4CA64EBL,
-	0x8AD958CFL, 0x78B2DBCCL, 0x6BE22838L, 0x9989AB3BL,
-	0x4D43CFD0L, 0xBF284CD3L, 0xAC78BF27L, 0x5E133C24L,
-	0x105EC76FL, 0xE235446CL, 0xF165B798L, 0x030E349BL,
-	0xD7C45070L, 0x25AFD373L, 0x36FF2087L, 0xC494A384L,
-	0x9A879FA0L, 0x68EC1CA3L, 0x7BBCEF57L, 0x89D76C54L,
-	0x5D1D08BFL, 0xAF768BBCL, 0xBC267848L, 0x4E4DFB4BL,
-	0x20BD8EDEL, 0xD2D60DDDL, 0xC186FE29L, 0x33ED7D2AL,
-	0xE72719C1L, 0x154C9AC2L, 0x061C6936L, 0xF477EA35L,
-	0xAA64D611L, 0x580F5512L, 0x4B5FA6E6L, 0xB93425E5L,
-	0x6DFE410EL, 0x9F95C20DL, 0x8CC531F9L, 0x7EAEB2FAL,
-	0x30E349B1L, 0xC288CAB2L, 0xD1D83946L, 0x23B3BA45L,
-	0xF779DEAEL, 0x05125DADL, 0x1642AE59L, 0xE4292D5AL,
-	0xBA3A117EL, 0x4851927DL, 0x5B016189L, 0xA96AE28AL,
-	0x7DA08661L, 0x8FCB0562L, 0x9C9BF696L, 0x6EF07595L,
-	0x417B1DBCL, 0xB3109EBFL, 0xA0406D4BL, 0x522BEE48L,
-	0x86E18AA3L, 0x748A09A0L, 0x67DAFA54L, 0x95B17957L,
-	0xCBA24573L, 0x39C9C670L, 0x2A993584L, 0xD8F2B687L,
-	0x0C38D26CL, 0xFE53516FL, 0xED03A29BL, 0x1F682198L,
-	0x5125DAD3L, 0xA34E59D0L, 0xB01EAA24L, 0x42752927L,
-	0x96BF4DCCL, 0x64D4CECFL, 0x77843D3BL, 0x85EFBE38L,
-	0xDBFC821CL, 0x2997011FL, 0x3AC7F2EBL, 0xC8AC71E8L,
-	0x1C661503L, 0xEE0D9600L, 0xFD5D65F4L, 0x0F36E6F7L,
-	0x61C69362L, 0x93AD1061L, 0x80FDE395L, 0x72966096L,
-	0xA65C047DL, 0x5437877EL, 0x4767748AL, 0xB50CF789L,
-	0xEB1FCBADL, 0x197448AEL, 0x0A24BB5AL, 0xF84F3859L,
-	0x2C855CB2L, 0xDEEEDFB1L, 0xCDBE2C45L, 0x3FD5AF46L,
-	0x7198540DL, 0x83F3D70EL, 0x90A324FAL, 0x62C8A7F9L,
-	0xB602C312L, 0x44694011L, 0x5739B3E5L, 0xA55230E6L,
-	0xFB410CC2L, 0x092A8FC1L, 0x1A7A7C35L, 0xE811FF36L,
-	0x3CDB9BDDL, 0xCEB018DEL, 0xDDE0EB2AL, 0x2F8B6829L,
-	0x82F63B78L, 0x709DB87BL, 0x63CD4B8FL, 0x91A6C88CL,
-	0x456CAC67L, 0xB7072F64L, 0xA457DC90L, 0x563C5F93L,
-	0x082F63B7L, 0xFA44E0B4L, 0xE9141340L, 0x1B7F9043L,
-	0xCFB5F4A8L, 0x3DDE77ABL, 0x2E8E845FL, 0xDCE5075CL,
-	0x92A8FC17L, 0x60C37F14L, 0x73938CE0L, 0x81F80FE3L,
-	0x55326B08L, 0xA759E80BL, 0xB4091BFFL, 0x466298FCL,
-	0x1871A4D8L, 0xEA1A27DBL, 0xF94AD42FL, 0x0B21572CL,
-	0xDFEB33C7L, 0x2D80B0C4L, 0x3ED04330L, 0xCCBBC033L,
-	0xA24BB5A6L, 0x502036A5L, 0x4370C551L, 0xB11B4652L,
-	0x65D122B9L, 0x97BAA1BAL, 0x84EA524EL, 0x7681D14DL,
-	0x2892ED69L, 0xDAF96E6AL, 0xC9A99D9EL, 0x3BC21E9DL,
-	0xEF087A76L, 0x1D63F975L, 0x0E330A81L, 0xFC588982L,
-	0xB21572C9L, 0x407EF1CAL, 0x532E023EL, 0xA145813DL,
-	0x758FE5D6L, 0x87E466D5L, 0x94B49521L, 0x66DF1622L,
-	0x38CC2A06L, 0xCAA7A905L, 0xD9F75AF1L, 0x2B9CD9F2L,
-	0xFF56BD19L, 0x0D3D3E1AL, 0x1E6DCDEEL, 0xEC064EEDL,
-	0xC38D26C4L, 0x31E6A5C7L, 0x22B65633L, 0xD0DDD530L,
-	0x0417B1DBL, 0xF67C32D8L, 0xE52CC12CL, 0x1747422FL,
-	0x49547E0BL, 0xBB3FFD08L, 0xA86F0EFCL, 0x5A048DFFL,
-	0x8ECEE914L, 0x7CA56A17L, 0x6FF599E3L, 0x9D9E1AE0L,
-	0xD3D3E1ABL, 0x21B862A8L, 0x32E8915CL, 0xC083125FL,
-	0x144976B4L, 0xE622F5B7L, 0xF5720643L, 0x07198540L,
-	0x590AB964L, 0xAB613A67L, 0xB831C993L, 0x4A5A4A90L,
-	0x9E902E7BL, 0x6CFBAD78L, 0x7FAB5E8CL, 0x8DC0DD8FL,
-	0xE330A81AL, 0x115B2B19L, 0x020BD8EDL, 0xF0605BEEL,
-	0x24AA3F05L, 0xD6C1BC06L, 0xC5914FF2L, 0x37FACCF1L,
-	0x69E9F0D5L, 0x9B8273D6L, 0x88D28022L, 0x7AB90321L,
-	0xAE7367CAL, 0x5C18E4C9L, 0x4F48173DL, 0xBD23943EL,
-	0xF36E6F75L, 0x0105EC76L, 0x12551F82L, 0xE03E9C81L,
-	0x34F4F86AL, 0xC69F7B69L, 0xD5CF889DL, 0x27A40B9EL,
-	0x79B737BAL, 0x8BDCB4B9L, 0x988C474DL, 0x6AE7C44EL,
-	0xBE2DA0A5L, 0x4C4623A6L, 0x5F16D052L, 0xAD7D5351L
-};
+#include "crc32c_table.h"
 
-/*
- * Steps through buffer one byte at at time, calculates reflected
- * crc using table.
- */
+#if CRC32C_BITS == 32
+/* slice by 4 algorithm */
+static u32 crc32c_body(u32 crc, u8 const *buf, size_t len)
+{
+	const u8 *p8;
+	const u32 *p32;
+	size_t init_bytes;
+	size_t words;
+	size_t end_bytes;
+	size_t i;
+	u32 q;
+	u8 i0, i1, i2, i3;
+
+	crc = (__force u32) __cpu_to_le32(crc);
+
+	/* unroll loop into 'init_bytes' odd bytes followed by
+	 * 'words' aligned 4 byte words followed by
+	 * 'end_bytes' odd bytes at the end */
+	p8 = buf;
+	p32 = (u32 *)PTR_ALIGN(p8, 4);
+	init_bytes = min((uintptr_t)p32 - (uintptr_t)p8, len);
+	words = (len - init_bytes) >> 2;
+	end_bytes = (len - init_bytes) & 3;
+
+	for (i = 0; i < init_bytes; i++) {
+#ifdef __LITTLE_ENDIAN
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
+#ifdef __LITTLE_ENDIAN
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
+	p8 = (u8 *)(++p32);
+
+	for (i = 0; i < end_bytes; i++) {
+#ifdef __LITTLE_ENDIAN
+		i0 = *p8++ ^ crc;
+		crc = t0_le[i0] ^ (crc >> 8);
+#else
+		i0 = *p8++ ^ (crc >> 24);
+		crc = t0_le[i0] ^ (crc << 8);
+#endif
+	}
 
-static u32 crc32c(u32 crc, const u8 *data, unsigned int length)
+	return __le32_to_cpu((__force __le32)crc);
+}
+#endif
+
+#if CRC32C_BITS == 64
+/* slice by 8 algorithm */
+static u32 crc32c_body(u32 crc, u8 const *buf, size_t len)
 {
-	while (length--)
-		crc = crc32c_table[(crc ^ *data++) & 0xFFL] ^ (crc >> 8);
+	const u8 *p8;
+	const u32 *p32;
+	size_t init_bytes;
+	size_t words;
+	size_t end_bytes;
+	size_t i;
+	u32 q;
+	u8 i0, i1, i2, i3;
+
+	crc = (__force u32) __cpu_to_le32(crc);
+
+	p8 = buf;
+	p32 = (u32 *)PTR_ALIGN(p8, 8);
+	i = (void *)p32 - (void *)p8;
+	init_bytes = min(i, len);
+	words = (len - init_bytes) >> 3;
+	end_bytes = (len - init_bytes) & 7;
+
+	for (i = 0; i < init_bytes; i++) {
+#ifdef __LITTLE_ENDIAN
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
+#ifdef __LITTLE_ENDIAN
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
 
+	p8 = (u8 *)(++p32);
+
+	for (i = 0; i < end_bytes; i++) {
+#ifdef __LITTLE_ENDIAN
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
+/**
+ * crc32c() - Calculate bitwise little-endian CRC32c.
+ * @crc: seed value for computation.  ~0 for ext4, sometimes 0 for
+ *	other uses, or the previous crc32c value if computing incrementally.
+ * @p: pointer to buffer over which CRC is run
+ * @len: length of buffer @p
+ */
+static u32 crc32c(u32 crc, unsigned char const *p, size_t len)
+{
+#if CRC32C_BITS == 1
+	int i;
+	while (len--) {
+		crc ^= *p++;
+		for (i = 0; i < 8; i++)
+			crc = (crc >> 1) ^ ((crc & 1) ? CRC32C_POLY_LE : 0);
+	}
+# elif CRC32C_BITS == 2
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+		crc = (crc >> 2) ^ t0_le[crc & 0x03];
+	}
+# elif CRC32C_BITS == 4
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 4) ^ t0_le[crc & 0x0f];
+		crc = (crc >> 4) ^ t0_le[crc & 0x0f];
+	}
+# elif CRC32C_BITS == 8
+	while (len--) {
+		crc ^= *p++;
+		crc = (crc >> 8) ^ t0_le[crc & 0xff];
+	}
+# else
+	crc = crc32c_body(crc, p, len);
+# endif
 	return crc;
 }
 
diff --git a/crypto/crc32c_defs.h b/crypto/crc32c_defs.h
new file mode 100644
index 0000000..ea4480d
--- /dev/null
+++ b/crypto/crc32c_defs.h
@@ -0,0 +1,39 @@
+#ifndef CRC32C_DEFS_H_
+#define CRC32C_DEFS_H_
+
+/*
+ * This is the CRC32c polynomial, as outlined by Castagnoli.
+ * x^32+x^28+x^27+x^26+x^25+x^23+x^22+x^20+x^19+x^18+x^14+x^13+x^11+x^10+x^9+
+ * x^8+x^6+x^0
+ */
+#define CRC32C_POLY_LE 0x82F63B78
+
+/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64. */
+/* For less performance-sensitive, use 4 */
+#ifdef CONFIG_CRC32C_SLICEBY8
+# define CRC32C_BITS 64
+#endif
+#ifdef CONFIG_CRC32C_SLICEBY4
+# define CRC32C_BITS 32
+#endif
+#ifdef CONFIG_CRC32C_SARWATE
+# define CRC32C_BITS 8
+#endif
+#ifdef CONFIG_CRC32C_BIT
+# define CRC32C_BITS 1
+#endif
+
+#ifndef CRC32C_BITS
+# define CRC32C_BITS 64
+#endif
+
+/*
+ * Little-endian CRC computation.  Used with serial bit streams sent
+ * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
+ */
+#if CRC32C_BITS > 64 || CRC32C_BITS < 1 || CRC32C_BITS == 16 || \
+	CRC32C_BITS & CRC32C_BITS-1
+# error "CRC32C_BITS must be one of {1, 2, 4, 8, 32, 64}"
+#endif
+
+#endif /* CRC32C_DEFS_H_ */
diff --git a/crypto/gen_crc32ctable.c b/crypto/gen_crc32ctable.c
new file mode 100644
index 0000000..1715229
--- /dev/null
+++ b/crypto/gen_crc32ctable.c
@@ -0,0 +1,79 @@
+#include <stdio.h>
+#include "crc32c_defs.h"
+#include <inttypes.h>
+
+#define ENTRIES_PER_LINE 4
+
+#if CRC32C_BITS <= 8
+#define LE_TABLE_SIZE (1 << CRC32C_BITS)
+#else
+#define LE_TABLE_SIZE 256
+#endif
+
+static uint32_t crc32c_table[8][256];
+
+/**
+ * crc32c_init() - allocate and initialize LE table data
+ *
+ * crc is the crc of the byte i; other entries are filled in based on the
+ * fact that crctable[i^j] = crctable[i] ^ crctable[j].
+ *
+ */
+static void crc32c_init(void)
+{
+	unsigned i, j;
+	uint32_t crc = 1;
+
+	crc32c_table[0][0] = 0;
+
+	for (i = LE_TABLE_SIZE >> 1; i; i >>= 1) {
+		crc = (crc >> 1) ^ ((crc & 1) ? CRC32C_POLY_LE : 0);
+		for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
+			crc32c_table[0][i + j] = crc ^ crc32c_table[0][j];
+	}
+	for (i = 0; i < LE_TABLE_SIZE; i++) {
+		crc = crc32c_table[0][i];
+		for (j = 1; j < 8; j++) {
+			crc = crc32c_table[0][crc & 0xff] ^ (crc >> 8);
+			crc32c_table[j][i] = crc;
+		}
+	}
+}
+
+static void output_table(uint32_t table[8][256], int len, char trans)
+{
+	int i, j;
+
+	for (j = 0 ; j < 8; j++) {
+		printf("static const u32 t%d_%ce[] = {", j, trans);
+		for (i = 0; i < len - 1; i++) {
+			if ((i % ENTRIES_PER_LINE) == 0)
+				printf("\n");
+			printf("to%ce(0x%8.8xL),", trans, table[j][i]);
+			if ((i % ENTRIES_PER_LINE) != (ENTRIES_PER_LINE - 1))
+				printf(" ");
+		}
+		printf("to%ce(0x%8.8xL)};\n\n", trans, table[j][len - 1]);
+
+		if ((j+1)*8 >= CRC32C_BITS)
+			break;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	printf("/*\n");
+	printf(" * crc32c_table.h - CRC32c tables\n");
+	printf(" *    this file is generated - do not edit\n");
+	printf(" *	# gen_crc32ctable > crc32c_table.h\n");
+	printf(" *    with\n");
+	printf(" *	CRC32C_BITS = %d\n", CRC32C_BITS);
+	printf(" */\n");
+
+	if (CRC32C_BITS > 1) {
+		crc32c_init();
+		output_table(crc32c_table, LE_TABLE_SIZE, 'l');
+	}
+
+	return 0;
+}
