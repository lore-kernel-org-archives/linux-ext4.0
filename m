From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 6/10] Add EXT2_HASH_UNSIGNED instead of magic constant 3
Date: 23 Sep 2014 06:17:59 -0400
Message-ID: <20140923101759.2584.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:36744 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754710AbaIWKSA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:18:00 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This can be changed later, allowing additional hash algorithms.

Signed-off-by: George Spelvin <linux@horizon.com>
---
The code now jumps to e2fsprogs.  The patches are mostly analagous
to the kernel ones.

 debugfs/htree.c      |  2 +-
 e2fsck/pass2.c       |  2 +-
 e2fsck/rehash.c      |  4 ++--
 lib/ext2fs/dirhash.c | 14 ++++----------
 lib/ext2fs/ext2_fs.h | 15 ++++++++++++---
 5 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 4f0118d..4ab1a4c 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -68,7 +68,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	hash_alg = rootnode->hash_version;
 	if ((hash_alg <= EXT2_HASH_TEA) &&
 	    (fs->super->s_flags & EXT2_FLAGS_UNSIGNED_HASH))
-		hash_alg += 3;
+		hash_alg += EXT2_HASH_UNSIGNED;
 
 	while (offset < fs->blocksize) {
 		dirent = (struct ext2_dir_entry *) (buf + offset);
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 0b9c5c5..454bbdc 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1003,7 +1003,7 @@ inline_read_fail:
 			dx_dir->hashversion = root->hash_version;
 			if ((dx_dir->hashversion <= EXT2_HASH_TEA) &&
 			    (fs->super->s_flags & EXT2_FLAGS_UNSIGNED_HASH))
-				dx_dir->hashversion += 3;
+				dx_dir->hashversion += EXT2_HASH_UNSIGNED;
 			dx_dir->depth = root->indirect_levels + 1;
 		} else if ((dirent->inode == 0) &&
 			   (rec_len == fs->blocksize) &&
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index e37e871..e48feb7 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -138,7 +138,7 @@ static int fill_dir_block(ext2_filsys fs,
 	hash_alg = fs->super->s_def_hash_version;
 	if ((hash_alg <= EXT2_HASH_TEA) &&
 	    (fs->super->s_flags & EXT2_FLAGS_UNSIGNED_HASH))
-		hash_alg += 3;
+		hash_alg += EXT2_HASH_UNSIGNED;
 	/* While the directory block is "hot", index it. */
 	dir_offset = 0;
 	while (dir_offset < fs->blocksize) {
@@ -375,7 +375,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 	hash_alg = fs->super->s_def_hash_version;
 	if ((hash_alg <= EXT2_HASH_TEA) &&
 	    (fs->super->s_flags & EXT2_FLAGS_UNSIGNED_HASH))
-		hash_alg += 3;
+		hash_alg += EXT2_HASH_UNSIGNED;
 
 	for (i=1; i < fd->num_array; i++) {
 		ent = fd->harray + i;
diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index c4ac94e..ef7820c 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -197,7 +197,7 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 	const char	*p;
 	int		i;
 	__u32 		in[8], buf[4];
-	int		unsigned_flag = 0;
+	int		unsigned_flag = (version >= EXT2_HASH_UNSIGNED);
 
 	/* Initialize the default seed for the hash checksum functions */
 	buf[0] = 0x67452301;
@@ -216,16 +216,12 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 	}
 
 	switch (version) {
-	case EXT2_HASH_LEGACY_UNSIGNED:
-		unsigned_flag++;
-		/* fallthrough */
 	case EXT2_HASH_LEGACY:
+	case EXT2_HASH_LEGACY_UNSIGNED:
 		hash = dx_hack_hash(name, len, unsigned_flag);
 		break;
-	case EXT2_HASH_HALF_MD4_UNSIGNED:
-		unsigned_flag++;
-		/* fallthrough */
 	case EXT2_HASH_HALF_MD4:
+	case EXT2_HASH_HALF_MD4_UNSIGNED:
 		p = name;
 		while (len > 0) {
 			str2hashbuf(p, len, in, 8, unsigned_flag);
@@ -236,10 +232,8 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 		minor_hash = buf[2];
 		hash = buf[1];
 		break;
-	case EXT2_HASH_TEA_UNSIGNED:
-		unsigned_flag++;
-		/* fallthrough */
 	case EXT2_HASH_TEA:
+	case EXT2_HASH_TEA_UNSIGNED:
 		p = name;
 		while (len > 0) {
 			str2hashbuf(p, len, in, 4, unsigned_flag);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index f9a4bdb..53df88c 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -226,9 +226,18 @@ struct ext2_dx_root_info {
 #define EXT2_HASH_LEGACY		0
 #define EXT2_HASH_HALF_MD4		1
 #define EXT2_HASH_TEA			2
-#define EXT2_HASH_LEGACY_UNSIGNED	3 /* reserved for userspace lib */
-#define EXT2_HASH_HALF_MD4_UNSIGNED	4 /* reserved for userspace lib */
-#define EXT2_HASH_TEA_UNSIGNED		5 /* reserved for userspace lib */
+
+/*
+ * For historical reasons, the first three hash algorithms
+ * have signed and unsigned variants.  So, for internal
+ * use only, define some extra values outside the range of
+ * what's allowed on disk.
+ */
+#define EXT2_HASH_UNSIGNED		3
+
+#define EXT2_HASH_LEGACY_UNSIGNED   (EXT2_HASH_UNSIGNED + EXT2_HASH_LEGACY)
+#define EXT2_HASH_HALF_MD4_UNSIGNED (EXT2_HASH_UNSIGNED + EXT2_HASH_HALF_MD4)
+#define EXT2_HASH_TEA_UNSIGNED      (EXT2_HASH_UNSIGNED + EXT2_HASH_TEA)
 
 #define EXT2_HASH_FLAG_INCOMPAT	0x1
 
-- 
2.1.0

