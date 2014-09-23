From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 4/10] lib/siphash.c: New file
Date: 23 Sep 2014 06:14:50 -0400
Message-ID: <20140923101450.32282.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:56043 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754550AbaIWKOw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:14:52 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

SipHash is a fast keyed hash function for short
inputs such as symbol tables and filenames.  It's
designed to prevent hash flooding DoS attacks.

This implements SipHash-2-4, the high-speed variant.

For now, ext3/4 are the only users, and the way the seed[] array
is passed is slightly idiosyncratic for their convenience.

Signed-off-by: George Spelvin <linux@horizon.com>
---
If anyone has any better ideas for the seed-passing convention, I'm
all ears.  For now, I've left it as is with plenty of warnings.

 include/linux/cryptohash.h |  19 +++++++
 lib/Makefile               |   2 +-
 lib/siphash.c              | 131 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+), 1 deletion(-)
 create mode 100644 lib/siphash.c

diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
index 2cd9f1cf..6b043780 100644
--- a/include/linux/cryptohash.h
+++ b/include/linux/cryptohash.h
@@ -1,6 +1,8 @@
 #ifndef __CRYPTOHASH_H
 #define __CRYPTOHASH_H
 
+#include <linux/compiler.h>
+
 #define SHA_DIGEST_WORDS 5
 #define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
 #define SHA_WORKSPACE_WORDS 16
@@ -15,4 +17,21 @@ void md5_transform(__u32 *hash, __u32 const *in);
 
 __u32 half_md4_transform(__u32 buf[4], __u32 const in[8]);
 
+/*
+ * Jean-Philippe Aumasson and Daniel J. Bernstein's SipHash-2-4.
+ *
+ * Takes an arbitrary-length byte string, returns a 64-bit hash value.
+ * Extremely fast on 64-bit machines.  Faster than half_md4_transform
+ * even on 32-bit machines.
+ *
+ * The fact that the seed is in the form of 4x32-bit words rather
+ * 2x64-bit, and NULL is a synonym for all-zero, is a convenience
+ * to the ext3/ext4 code which is the only current user.
+ *
+ * If it's used for internal hashing with a non-public seed, details
+ * like endianness don't matter.  If it's going to be used for something
+ * longer-term, please feel free to revise the interface.
+ */
+__u64 __pure siphash24(char const *in, size_t len, __u32 const seed[4]);
+
 #endif
diff --git a/lib/Makefile b/lib/Makefile
index f9a647d3..56d0e35b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -26,7 +26,7 @@ obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
-	 percpu-refcount.o percpu_ida.o hash.o
+	 percpu-refcount.o percpu_ida.o hash.o siphash.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
diff --git a/lib/siphash.c b/lib/siphash.c
new file mode 100644
index 00000000..77e8fb4f
--- /dev/null
+++ b/lib/siphash.c
@@ -0,0 +1,131 @@
+#include <linux/bitops.h>	/* For rol64 */
+#include <linux/cryptohash.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
+
+/* The basic ARX mixing function, taken from Skein */
+#define SIP_MIX(a, b, s) ((a) += (b), (b) = rol64(b, s), (b) ^= (a))
+
+/*
+ * The complete SipRound.  Note that, when unrolled twice like below,
+ * the 32-bit rotates drop out on 32-bit machines.
+ */
+#define SIP_ROUND(a, b, c, d) \
+	(SIP_MIX(a, b, 13), SIP_MIX(c, d, 16), (a) = rol64(a, 32), \
+	 SIP_MIX(c, b, 17), SIP_MIX(a, d, 21), (c) = rol64(c, 32))
+
+/*
+ * This is rolled up more than most implementations, resulting in about
+ * 55% the code size.  Speed is a few precent slower.  A crude benchmark
+ * (for (i=1; i <= max; i++) for (j = 0; j < 4096-i; j++) hash(buf+j, i);)
+ * produces the following timings (in usec):
+ *
+ *		i386	i386	i386	x86_64	x86_64	x86_64	x86_64
+ * Length	small	unroll  halfmd4 small	unroll	halfmd4 teahash
+ * 1..4		   1069	   1029	   1608	    195	    160	    399	    690
+ * 1..8		   2483	   2381	   3851	    410	    360	    988	   1659
+ * 1..12           4303	   4152	   6207	    690	    618	   1642	   2690
+ * 1..16           6122	   5931	   8668	    968	    876	   2363	   3786
+ * 1..20           8348	   8137	  11245	   1323	   1185	   3162	   5567
+ * 1..24          10580	  10327	  13935	   1657	   1504	   4066	   7635
+ * 1..28          13211	  12956	  16803	   2069	   1871	   5028	   9759
+ * 1..32          15843	  15572	  19725	   2470	   2260	   6084	  11932
+ * 1..36          18864	  18609	  24259	   2934	   2678	   7566	  14794
+ * 1..1024      5890194	6130242	10264816 881933	 881244	3617392	7589036
+ *
+ * The performance penalty is quite minor, decreasing for long strings,
+ * and it's significantly faster than half_md4, so I'm going for the
+ * I-cache win.
+ */
+uint64_t
+siphash24(char const *in, size_t len, uint32_t const seed[4])
+{
+	uint64_t a = 0x736f6d6570736575;	/* somepseu */
+	uint64_t b = 0x646f72616e646f6d;	/* dorandom */
+	uint64_t c = 0x6c7967656e657261;	/* lygenera */
+	uint64_t d = 0x7465646279746573;	/* tedbytes */
+	uint64_t m = 0;
+	uint8_t padbyte = len;
+
+	/*
+	 * Mix in the 128-bit hash seed.  This is in a format convenient
+	 * to the ext3/ext4 code.  Please feel free to adapt the
+	 * */
+	if (seed) {
+		m = seed[2] | (uint64_t)seed[3] << 32;
+		b ^= m;
+		d ^= m;
+		m = seed[0] | (uint64_t)seed[1] << 32;
+		/* a ^= m; is done in loop below */
+		c ^= m;
+	}
+
+	/*
+	 * By using the same SipRound code for all iterations, we
+	 * save space, at the expense of some branch prediction.  But
+	 * branch prediction is hard because of variable length anyway.
+	 */
+	len = len/8 + 3;	/* Now number of rounds to perform */
+	do {
+		a ^= m;
+
+		switch (--len) {
+			unsigned bytes;
+
+		default:	/* Full words */
+			d ^= m = get_unaligned_le64(in);
+			in += 8;
+			break;
+		case 2:		/* Final partial word */
+			/*
+			 * We'd like to do one 64-bit fetch rather than
+			 * mess around with bytes, but reading past the end
+			 * might hit a protection boundary.  Fortunately,
+			 * we know that protection boundaries are aligned,
+			 * so we can consider only three cases:
+			 * - The remainder occupies zero words
+			 * - The remainder fits into one word
+			 * - The remainder straddles two words
+			 */
+			bytes = padbyte & 7;
+
+			if (bytes == 0) {
+				m = 0;
+			} else {
+				unsigned offset = (unsigned)(uintptr_t)in & 7;
+
+				if (offset + bytes <= 8) {
+					m = le64_to_cpup((uint64_t const *)
+								(in - offset));
+					m >>= 8*offset;
+				} else {
+					m = get_unaligned_le64(in);
+				}
+				m &= ((uint64_t)1 << 8*bytes) - 1;
+			}
+			/* Could use | or +, but ^ allows associativity */
+			d ^= m ^= (uint64_t)padbyte << 56;
+			break;
+		case 1:		/* Beginning of finalization */
+			m = 0;
+			c ^= 0xff;
+			/*FALLTHROUGH*/
+		case 0:		/* Second half of finalization */
+			break;
+		}
+
+		SIP_ROUND(a, b, c, d);
+		SIP_ROUND(a, b, c, d);
+	} while (len);
+
+	return a ^ b ^ c ^ d;
+}
+
+#undef SIP_ROUND
+#undef SIP_MIX
+
+/*
+ * No objection to EXPORT_SYMBOL, but we should probably figure out
+ * how the seed[] array should work first.  Homework for the first
+ * person to want to call it from a module!
+ */
-- 
2.1.0

