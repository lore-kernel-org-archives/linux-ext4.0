From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 7/10] dirhash.c (ext2fs_dirhash): Remove redundant local variable p
Date: 23 Sep 2014 06:19:38 -0400
Message-ID: <20140923101938.3876.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:26901 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755171AbaIWKTk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:19:40 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This also makes the variable declarations line up better.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 lib/ext2fs/dirhash.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index ef7820c..048486e 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -194,10 +194,9 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 {
 	__u32	hash;
 	__u32	minor_hash = 0;
-	const char	*p;
-	int		i;
-	__u32 		in[8], buf[4];
-	int		unsigned_flag = (version >= EXT2_HASH_UNSIGNED);
+	int	i;
+	__u32 	in[8], buf[4];
+	int	unsigned_flag = (version >= EXT2_HASH_UNSIGNED);
 
 	/* Initialize the default seed for the hash checksum functions */
 	buf[0] = 0x67452301;
@@ -222,24 +221,22 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 		break;
 	case EXT2_HASH_HALF_MD4:
 	case EXT2_HASH_HALF_MD4_UNSIGNED:
-		p = name;
 		while (len > 0) {
-			str2hashbuf(p, len, in, 8, unsigned_flag);
+			str2hashbuf(name, len, in, 8, unsigned_flag);
 			halfMD4Transform(buf, in);
 			len -= 32;
-			p += 32;
+			name += 32;
 		}
 		minor_hash = buf[2];
 		hash = buf[1];
 		break;
 	case EXT2_HASH_TEA:
 	case EXT2_HASH_TEA_UNSIGNED:
-		p = name;
 		while (len > 0) {
-			str2hashbuf(p, len, in, 4, unsigned_flag);
+			str2hashbuf(name, len, in, 4, unsigned_flag);
 			TEA_transform(buf, in);
 			len -= 16;
-			p += 16;
+			name += 16;
 		}
 		hash = buf[0];
 		minor_hash = buf[1];
-- 
2.1.0

