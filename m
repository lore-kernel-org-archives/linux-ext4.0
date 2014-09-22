From: "George Spelvin" <linux@horizon.com>
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: 22 Sep 2014 19:14:12 -0400
Message-ID: <20140922231412.10387.qmail@ns.horizon.com>
References: <20140922170903.GC4572@thunk.org>
Cc: linux-ext4@vger.kernel.org, thomas_reardon@hotmail.com
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:42804 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755092AbaIVXOQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Sep 2014 19:14:16 -0400
In-Reply-To: <20140922170903.GC4572@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> In fact, I'm not sure if the code copes with more than 4096 bytes of
>> directory entry with a single hash value or it will cause some sort of
>> error.

> It does cope correctly, but it means that we degrade to doing a linear
> search.  At one point we had a test where we forced the hash algorithm
> to always return "42" to check those code paths.

Shame on me for not RTFS before impugning your code.
I just knew it broke the optimization.

Anyway, I'm working on patches.  Here's the start, which I hope is small
enough (2 patches: kernel, then e2fsprogs):

commit a4a2ee4011b2a6c844058d3a80d60fdc26f1607b
Author: George Spelvin <linux@horizon.com>
Date:   Mon Sep 22 22:40:30 2014 +0000

    ex4: Introduce DX_HASH_UNSIGNED_DELTA
    
    This makes it easier to add adidtional hash algorithms in future.

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1bbe7c31..cda8dd9c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1216,7 +1216,7 @@ struct ext4_sb_info {
 	u32 s_next_generation;
 	u32 s_hash_seed[4];
 	int s_def_hash_version;
-	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not */
+	int s_hash_unsigned;	/* DX_HASH_UNSIGNED_DELTA, or 0 if signed */
 	struct percpu_counter s_freeclusters_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
@@ -1737,9 +1737,18 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #define DX_HASH_LEGACY		0
 #define DX_HASH_HALF_MD4	1
 #define DX_HASH_TEA		2
-#define DX_HASH_LEGACY_UNSIGNED	3
-#define DX_HASH_HALF_MD4_UNSIGNED	4
-#define DX_HASH_TEA_UNSIGNED		5
+
+/*
+ * For historical reasons, the first three hash algorithms
+ * have signed and unsigned variants.  So, for internal
+ * use only, define some extra values outside the range of
+ * what's allowed on disk.
+ */
+#define DX_HASH_UNSIGNED_DELTA	3
+
+#define DX_HASH_LEGACY_UNSIGNED   (DX_HASH_LEGACY   + DX_HASH_UNSIGNED_DELTA)
+#define DX_HASH_HALF_MD4_UNSIGNED (DX_HASH_HALF_MD4 + DX_HASH_UNSIGNED_DELTA)
+#define DX_HASH_TEA_UNSIGNED      (DX_HASH_TEA      + DX_HASH_UNSIGNED_DELTA)
 
 static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 			      const void *address, unsigned int length)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4566c2fe..9a9c0bbb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3721,16 +3721,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
-	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+	if (sbi->s_def_hash_version <= DX_HASH_TEA &&
+            EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
 		i = le32_to_cpu(es->s_flags);
 		if (i & EXT2_FLAGS_UNSIGNED_HASH)
-			sbi->s_hash_unsigned = 3;
+			sbi->s_hash_unsigned = DX_HASH_UNSIGNED_DELTA;
 		else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
 #ifdef __CHAR_UNSIGNED__
 			if (!(sb->s_flags & MS_RDONLY))
 				es->s_flags |=
 					cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
-			sbi->s_hash_unsigned = 3;
+			sbi->s_hash_unsigned = DX_HASH_UNSIGNED_DELTA;
 #else
 			if (!(sb->s_flags & MS_RDONLY))
 				es->s_flags |=



commit a493f2d7e43922d0795089d7058812a607028d90
Author: George Spelvin <linux@horizon.com>
Date:   Mon Sep 22 22:54:32 2014 +0000

    Add EXT2_HASH_UNSIGNED instead of magic constant "3".
    
    This can be changed later, allowing additional hash algorithms.

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
 
