From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 9/10] Add EXT2_HASH_SIPHASH24 (=3)
Date: 23 Sep 2014 06:29:03 -0400
Message-ID: <20140923102903.15608.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:16985 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755467AbaIWK3F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:29:05 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As an alternate directory htree hash algorithm.

Signed-off-by: George Spelvin <linux@horizon.com>
---
Half of the actual implementation.

 e2fsck/pass1.c       | 1 +
 lib/ext2fs/dirhash.c | 6 ++++++
 lib/ext2fs/ext2_fs.h | 3 ++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 4fc5311..a89e556 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2228,6 +2228,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 	if ((root->hash_version != EXT2_HASH_LEGACY) &&
 	    (root->hash_version != EXT2_HASH_HALF_MD4) &&
 	    (root->hash_version != EXT2_HASH_TEA) &&
+	    (root->hash_version != EXT2_HASH_SIPHASH24) &&
 	    fix_problem(ctx, PR_1_HTREE_HASHV, pctx))
 		return 1;
 
diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index f51a342..bb81938 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -320,6 +320,7 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 {
 	__u32	hash;
 	__u32	minor_hash = 0;
+	__u64	hash64;
 	int	i;
 	__u32 	in[8], buf[4];
 	int	unsigned_flag = (version >= EXT2_HASH_UNSIGNED);
@@ -367,6 +368,11 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 		hash = buf[0];
 		minor_hash = buf[1];
 		break;
+	case EXT2_HASH_SIPHASH24:
+		hash64 = siphash24(name, len, seed);
+		hash = (__u32)hash64;
+		minor_hash = hash64 >> 32;
+		break;
 	default:
 		*ret_hash = 0;
 		return EXT2_ET_DIRHASH_UNSUPP;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 53df88c..7a487d9 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -226,6 +226,7 @@ struct ext2_dx_root_info {
 #define EXT2_HASH_LEGACY		0
 #define EXT2_HASH_HALF_MD4		1
 #define EXT2_HASH_TEA			2
+#define EXT2_HASH_SIPHASH24		3
 
 /*
  * For historical reasons, the first three hash algorithms
@@ -233,7 +234,7 @@ struct ext2_dx_root_info {
  * use only, define some extra values outside the range of
  * what's allowed on disk.
  */
-#define EXT2_HASH_UNSIGNED		3
+#define EXT2_HASH_UNSIGNED		4
 
 #define EXT2_HASH_LEGACY_UNSIGNED   (EXT2_HASH_UNSIGNED + EXT2_HASH_LEGACY)
 #define EXT2_HASH_HALF_MD4_UNSIGNED (EXT2_HASH_UNSIGNED + EXT2_HASH_HALF_MD4)
-- 
2.1.0

