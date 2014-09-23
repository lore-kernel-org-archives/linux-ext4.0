From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 2/10] ext4: Remove redundant local variable p from ext4fs_dirhash
Date: 23 Sep 2014 06:05:59 -0400
Message-ID: <20140923100559.27314.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:46112 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754134AbaIWKGB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:06:01 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Minor cleanup as long as I'm messing about in the area.

Signed-off-by: George Spelvin <linux@horizon.com>
---
The str2hashbuf declaration generates a checkpatch warning.  False positive?

 fs/ext4/hash.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 3d586f02..5186e09a 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -140,11 +140,10 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 {
 	__u32	hash;
 	__u32	minor_hash = 0;
-	const char	*p;
-	int		i;
-	__u32		in[8], buf[4];
-	void		(*str2hashbuf)(const char *, int, __u32 *, int) =
-				str2hashbuf_signed;
+	int	i;
+	__u32	in[8], buf[4];
+	void	(*str2hashbuf)(const char *, int, __u32 *, int) =
+			str2hashbuf_signed;
 
 	/* Initialize the default seed for the hash checksum functions */
 	buf[0] = 0x67452301;
@@ -172,12 +171,11 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 	case DX_HASH_HALF_MD4_UNSIGNED:
 		str2hashbuf = str2hashbuf_unsigned;
 	case DX_HASH_HALF_MD4:
-		p = name;
 		while (len > 0) {
-			(*str2hashbuf)(p, len, in, 8);
+			(*str2hashbuf)(name, len, in, 8);
 			half_md4_transform(buf, in);
 			len -= 32;
-			p += 32;
+			name += 32;
 		}
 		minor_hash = buf[2];
 		hash = buf[1];
@@ -185,12 +183,11 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 	case DX_HASH_TEA_UNSIGNED:
 		str2hashbuf = str2hashbuf_unsigned;
 	case DX_HASH_TEA:
-		p = name;
 		while (len > 0) {
-			(*str2hashbuf)(p, len, in, 4);
+			(*str2hashbuf)(name, len, in, 4);
 			TEA_transform(buf, in);
 			len -= 16;
-			p += 16;
+			name += 16;
 		}
 		hash = buf[0];
 		minor_hash = buf[1];
-- 
2.1.0

