From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 8/10] dirhash.c: Add siphash24()
Date: 23 Sep 2014 06:27:42 -0400
Message-ID: <20140923102742.13288.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:60150 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754974AbaIWK1p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:27:45 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Not hooked up to anything yet.

Signed-off-by: George Spelvin <linux@horizon.com>
---
Is there a nicer way to implement get_unaligned_le64()?
I know we all hate #ifdef, but I was tempted by the Dark Side.

 lib/ext2fs/dirhash.c | 126 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index 048486e..f51a342 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -14,6 +14,7 @@
 #include "config.h"
 #include <stdio.h>
 #include <string.h>
+#include <stdint.h>
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
@@ -174,6 +175,131 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num,
 		*buf++ = pad;
 }
 
+#if __i386 || __x86_64
+/* This is such a common case it's worth optimizing */
+# define get_unaligned_le64(p) (*(const __u64 *)(p))
+#else
+#if __GNUC__ >= 3
+__attribute__ ((__pure__))
+#endif
+static __u64 get_unaligned_le64(const void *p)
+{
+	const __u8 *q = p;
+
+	return	(__u64)q[0] |
+		(__u64)q[1] << 8 |
+		(__u64)q[2] << 16 |
+		(__u64)q[3] << 24 |
+		(__u64)q[4] << 32 |
+		(__u64)q[5] << 40 |
+		(__u64)q[6] << 48 |
+		(__u64)q[7] << 56;
+}
+#endif
+
+#define rol64(x, s) ((x) << (s) | (x) >> (64 - (s)))
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
+#if __GNUC__ >= 3
+__attribute__ ((__pure__))
+#endif
+static __u64
+siphash24(char const *in, size_t len, __u32 const seed[4])
+{
+	__u64	a = 0x736f6d6570736575ull;	/* somepseu */
+	__u64	b = 0x646f72616e646f6dull;	/* dorandom */
+	__u64	c = 0x6c7967656e657261ull;	/* lygenera */
+	__u64	d = 0x7465646279746573ull;	/* tedbytes */
+	__u64	m = 0;
+	__u8	padbyte = len;
+
+	/*
+	 * Mix in the 128-bit hash seed.  This is in a format convenient
+	 * to the ext3/ext4 code.  Please feel free to adapt the
+	 * */
+	if (seed) {
+		m = seed[2] | (__u64)seed[3] << 32;
+		b ^= m;
+		d ^= m;
+		m = seed[0] | (__u64)seed[1] << 32;
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
+					m = ext2fs_le64_to_cpu(*(__u64 const *)
+								(in - offset));
+					m >>= 8*offset;
+				} else {
+					m = get_unaligned_le64(in);
+				}
+				m &= ((__u64)1 << 8*bytes) - 1;
+			}
+			/* Could use | or +, but ^ allows associativity */
+			d ^= m ^= (__u64)padbyte << 56;
+			break;
+		case 1:		/* Beginning of finalization */
+			m = 0;
+			c ^= 0xff;
+			/*FALLTHROUGH*/
+		case 0:
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
 /*
  * Returns the hash of a filename.  If len is 0 and name is NULL, then
  * this function can be used to test whether or not a hash version is
-- 
2.1.0

