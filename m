From: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Subject: [PATCH] lib/ext2fs/bitops.h: Use the optmized/documented byteswapping routines
Date: Sat, 12 Jan 2013 16:32:25 -0300
Message-ID: <1358019145-2774-1-git-send-email-crrodriguez@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ye0-f180.google.com ([209.85.213.180]:61472 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab3AMTlc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 14:41:32 -0500
Received: by mail-ye0-f180.google.com with SMTP id m9so581428yen.39
        for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2013 11:41:31 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In x86, it will not make much difference but other targets that
are not covered by the old code will be able to generate better code.

Signed-off-by: Cristian Rodr=C3=ADguez <crrodriguez@opensuse.org>
---
 lib/ext2fs/bitops.h | 91 +++++++++++----------------------------------=
--------
 1 file changed, 18 insertions(+), 73 deletions(-)

diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 1559539..8437b1e 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -10,33 +10,24 @@
  * %End-Header%
  */
=20
-#ifdef WORDS_BIGENDIAN
-#define ext2fs_cpu_to_le64(x) ext2fs_swab64((x))
-#define ext2fs_le64_to_cpu(x) ext2fs_swab64((x))
-#define ext2fs_cpu_to_le32(x) ext2fs_swab32((x))
-#define ext2fs_le32_to_cpu(x) ext2fs_swab32((x))
-#define ext2fs_cpu_to_le16(x) ext2fs_swab16((x))
-#define ext2fs_le16_to_cpu(x) ext2fs_swab16((x))
-#define ext2fs_cpu_to_be64(x) ((__u64)(x))
-#define ext2fs_be64_to_cpu(x) ((__u64)(x))
-#define ext2fs_cpu_to_be32(x) ((__u32)(x))
-#define ext2fs_be32_to_cpu(x) ((__u32)(x))
-#define ext2fs_cpu_to_be16(x) ((__u16)(x))
-#define ext2fs_be16_to_cpu(x) ((__u16)(x))
-#else
-#define ext2fs_cpu_to_le64(x) ((__u64)(x))
-#define ext2fs_le64_to_cpu(x) ((__u64)(x))
-#define ext2fs_cpu_to_le32(x) ((__u32)(x))
-#define ext2fs_le32_to_cpu(x) ((__u32)(x))
-#define ext2fs_cpu_to_le16(x) ((__u16)(x))
-#define ext2fs_le16_to_cpu(x) ((__u16)(x))
-#define ext2fs_cpu_to_be64(x) ext2fs_swab64((x))
-#define ext2fs_be64_to_cpu(x) ext2fs_swab64((x))
-#define ext2fs_cpu_to_be32(x) ext2fs_swab32((x))
-#define ext2fs_be32_to_cpu(x) ext2fs_swab32((x))
-#define ext2fs_cpu_to_be16(x) ext2fs_swab16((x))
-#define ext2fs_be16_to_cpu(x) ext2fs_swab16((x))
-#endif
+#include <byteswap.h>
+#include <endian.h>
+
+#define ext2fs_swab32(x)    bswap_32(x)
+#define ext2fs_swab16(x)    bswap_16(x)
+#define ext2fs_swab64(x)    bswap_64(x)
+#define ext2fs_cpu_to_le64(x) htole64((x))
+#define ext2fs_le64_to_cpu(x) le64toh((x))
+#define ext2fs_cpu_to_le32(x) htole32((x))
+#define ext2fs_le32_to_cpu(x) le32toh((x))
+#define ext2fs_cpu_to_le16(x) htole16((x))
+#define ext2fs_le16_to_cpu(x) le16toh((x))
+#define ext2fs_cpu_to_be64(x) htobe64((x))
+#define ext2fs_be64_to_cpu(x) be64toh((x))
+#define ext2fs_cpu_to_be32(x) htobe32((x))
+#define ext2fs_be32_to_cpu(x) be32toh((x))
+#define ext2fs_cpu_to_be16(x) htobe16((x))
+#define ext2fs_be16_to_cpu(x) be16toh((x))
=20
 /*
  * EXT2FS bitmap manipulation routines.
@@ -319,54 +310,11 @@ _INLINE_ int ext2fs_test_bit(unsigned int nr, con=
st void * addr)
 	return oldbit;
 }
=20
-_INLINE_ __u32 ext2fs_swab32(__u32 val)
-{
-#ifdef EXT2FS_REQUIRE_486
-	__asm__("bswap %0" : "=3Dr" (val) : "0" (val));
-#else
-	__asm__("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
-		"rorl $16,%0\n\t"	/* swap words		*/
-		"xchgb %b0,%h0"		/* swap higher bytes	*/
-		:"=3Dq" (val)
-		: "0" (val));
-#endif
-	return val;
-}
-
-_INLINE_ __u16 ext2fs_swab16(__u16 val)
-{
-	__asm__("xchgb %b0,%h0"		/* swap bytes		*/ \
-		: "=3Dq" (val) \
-		:  "0" (val)); \
-		return val;
-}
-
 #undef EXT2FS_ADDR
=20
 #endif	/* i386 */
=20
=20
-#if !defined(_EXT2_HAVE_ASM_SWAB_)
-
-_INLINE_ __u16 ext2fs_swab16(__u16 val)
-{
-	return (val >> 8) | (val << 8);
-}
-
-_INLINE_ __u32 ext2fs_swab32(__u32 val)
-{
-	return ((val>>24) | ((val>>8)&0xFF00) |
-		((val<<8)&0xFF0000) | (val<<24));
-}
-
-#endif /* !_EXT2_HAVE_ASM_SWAB */
-
-_INLINE_ __u64 ext2fs_swab64(__u64 val)
-{
-	return (ext2fs_swab32(val >> 32) |
-		(((__u64)ext2fs_swab32(val & 0xFFFFFFFFUL)) << 32));
-}
