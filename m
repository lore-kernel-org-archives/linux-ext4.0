From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 5/10] ext4: Add DX_HASH_SIPHASH24 support
Date: 23 Sep 2014 06:16:12 -0400
Message-ID: <20140923101612.930.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:54249 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754070AbaIWKQN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:16:13 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This uses SipHash-2-4 for directory hashing.

Signed-off-by: George Spelvin <linux@horizon.com>
---
The actual feature.  Pretty simple, no?

 fs/ext4/ext4.h  | 3 ++-
 fs/ext4/hash.c  | 6 ++++++
 fs/ext4/namei.c | 3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cda8dd9c..13420bd4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1737,6 +1737,7 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #define DX_HASH_LEGACY		0
 #define DX_HASH_HALF_MD4	1
 #define DX_HASH_TEA		2
+#define DX_HASH_SIPHASH24	3
 
 /*
  * For historical reasons, the first three hash algorithms
@@ -1744,7 +1745,7 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
  * use only, define some extra values outside the range of
  * what's allowed on disk.
  */
-#define DX_HASH_UNSIGNED_DELTA	3
+#define DX_HASH_UNSIGNED_DELTA	4
 
 #define DX_HASH_LEGACY_UNSIGNED   (DX_HASH_LEGACY   + DX_HASH_UNSIGNED_DELTA)
 #define DX_HASH_HALF_MD4_UNSIGNED (DX_HASH_HALF_MD4 + DX_HASH_UNSIGNED_DELTA)
diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 5186e09a..584639f4 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -140,6 +140,7 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 {
 	__u32	hash;
 	__u32	minor_hash = 0;
+	__u64	hash64;
 	int	i;
 	__u32	in[8], buf[4];
 	void	(*str2hashbuf)(const char *, int, __u32 *, int) =
@@ -192,6 +193,11 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 		hash = buf[0];
 		minor_hash = buf[1];
 		break;
+	case DX_HASH_SIPHASH24:
+		hash64 = siphash24(name, len, hinfo->seed);
+		hash = (__u32)hash64;
+		minor_hash = hash64 >> 32;
+		break;
 	default:
 		hinfo->hash = 0;
 		return -1;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9e6eced1..922d6b48 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -685,7 +685,8 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
 		goto fail;
 	}
 	root = (struct dx_root *) bh->b_data;
-	if (root->info.hash_version != DX_HASH_TEA &&
+	if (root->info.hash_version != DX_HASH_SIPHASH24 &&
+	    root->info.hash_version != DX_HASH_TEA &&
 	    root->info.hash_version != DX_HASH_HALF_MD4 &&
 	    root->info.hash_version != DX_HASH_LEGACY) {
 		ext4_warning(dir->i_sb, "Unrecognised inode hash code %d",
-- 
2.1.0

