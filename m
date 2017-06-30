From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH v2] e2fsprogs: add ext2fs_is_fast_symlink() function
Date: Thu, 29 Jun 2017 18:36:08 -0700
Message-ID: <20170630013608.29185-1-tahsin@google.com>
References: <20170630013159.28178-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36247 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbdF3BgN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jun 2017 21:36:13 -0400
Received: by mail-pf0-f176.google.com with SMTP id q86so58874344pfl.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Jun 2017 18:36:13 -0700 (PDT)
In-Reply-To: <20170630013159.28178-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current way of determining whether a symlink is in fast symlink
format is to call ext2fs_inode_data_blocks2(). If number of data
blocks is zero and EXT4_INLINE_DATA_FL flag is not set, then symlink
data must be in inode->i_block.

This heuristic is becoming increasingly hard to maintain because
inode->i_blocks count can also be incremented for blocks used by
extended attributes. Before ea_inode feature, extra block could come
from xattr block, now more blocks can be added because of xattr
inodes.

To address the issue, add a ext2fs_is_fast_symlink() function that
gives a direct answer based on inode->i_size field. This is
equivalent to kernel's ext4_inode_is_fast_symlink() function.

This patch also fixes a few issues related to fast symlink handling:

  - Both rdump_symlink() and follow_link() interpreted symlinks with
    0 data blocks to always mean fast symlinks. This is incorrect
    because symlinks that are stored as inline data also have
    0 data blocks. Thus, they try to read everything from
    inode->i_block and miss the symlink suffix in inode extra area.

  - e2fsck_pass1_check_symlink() had code to handle inode with
    EXT4_INLINE_DATA_FL flag twice. The first if block always returns
    from the function so the second one is unreachable code.

Suggested-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
v2: Added Suggested-by to commit message

 debugfs/debugfs.c    | 55 +++++++++++++++++++++++-----------------------------
 debugfs/dump.c       |  4 +---
 e2fsck/pass1.c       | 42 ++++++++-------------------------------
 lib/ext2fs/alloc.c   |  9 +++++----
 lib/ext2fs/ext2fs.h  |  1 +
 lib/ext2fs/namei.c   | 20 ++++++++++++++++---
 lib/ext2fs/swapfs.c  | 46 +++++++++++++++++++++----------------------
 lib/ext2fs/symlink.c | 11 +++++++++++
 misc/fuse2fs.c       |  9 ++++-----
 9 files changed, 94 insertions(+), 103 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index cef4ec2834fa..0a4b536bc25a 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -778,41 +778,31 @@ static void dump_inline_data(FILE *out, const char *prefix, ext2_ino_t inode_num
 		fprintf(out, "%sSize of inline data: %zu\n", prefix, size);
 }
 
-static void dump_fast_link(FILE *out, ext2_ino_t inode_num,
-			   struct ext2_inode *inode, const char *prefix)
+static void dump_inline_symlink(FILE *out, ext2_ino_t inode_num,
+				struct ext2_inode *inode, const char *prefix)
 {
-	errcode_t retval = 0;
-	char *buf;
+	errcode_t retval;
+	char *buf = NULL;
 	size_t size;
 
-	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
-		retval = ext2fs_inline_data_size(current_fs, inode_num, &size);
-		if (retval)
-			goto out;
-
-		retval = ext2fs_get_memzero(size + 1, &buf);
-		if (retval)
-			goto out;
+	retval = ext2fs_inline_data_size(current_fs, inode_num, &size);
+	if (retval)
+		goto out;
 
-		retval = ext2fs_inline_data_get(current_fs, inode_num,
-						inode, buf, &size);
-		if (retval)
-			goto out;
-		fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix,
-			(int)size, buf);
+	retval = ext2fs_get_memzero(size + 1, &buf);
+	if (retval)
+		goto out;
 
-		retval = ext2fs_free_mem(&buf);
-		if (retval)
-			goto out;
-	} else {
-		size_t sz = EXT2_I_SIZE(inode);
+	retval = ext2fs_inline_data_get(current_fs, inode_num,
+					inode, buf, &size);
+	if (retval)
+		goto out;
 
-		if (sz > sizeof(inode->i_block))
-			sz = sizeof(inode->i_block);
-		fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix, (int) sz,
-			(char *)inode->i_block);
-	}
+	fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix,
+		(int)size, buf);
 out:
+	if (buf)
+		ext2fs_free_mem(&buf);
 	if (retval)
 		com_err(__func__, retval, "while dumping link destination");
 }
@@ -938,9 +928,12 @@ void internal_dump_inode(FILE *out, const char *prefix,
 		fprintf(out, "Inode checksum: 0x%08x\n", crc);
 	}
 
-	if (LINUX_S_ISLNK(inode->i_mode) &&
-	    ext2fs_inode_data_blocks(current_fs, inode) == 0)
-		dump_fast_link(out, inode_num, inode, prefix);
+	if (LINUX_S_ISLNK(inode->i_mode) && ext2fs_is_fast_symlink(inode))
+		fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix,
+			(int)EXT2_I_SIZE(inode), (char *)inode->i_block);
+	else if (LINUX_S_ISLNK(inode->i_mode) &&
+		   (inode->i_flags & EXT4_INLINE_DATA_FL))
+		dump_inline_symlink(out, inode_num, inode, prefix);
 	else if (LINUX_S_ISBLK(inode->i_mode) || LINUX_S_ISCHR(inode->i_mode)) {
 		int major, minor;
 		const char *devnote;
diff --git a/debugfs/dump.c b/debugfs/dump.c
index 4d3865153ce0..4d5daf0ac5eb 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -208,9 +208,7 @@ static void rdump_symlink(ext2_ino_t ino, struct ext2_inode *inode,
 		goto errout;
 	}
 
-	/* Apparently, this is the right way to detect and handle fast
-	 * symlinks; see do_stat() in debugfs.c. */
-	if (ext2fs_inode_data_blocks2(current_fs, inode) == 0)
+	if (ext2fs_is_fast_symlink(inode))
 		strcpy(buf, (char *) inode->i_block);
 	else {
 		unsigned bytes = inode->i_size;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 422a3d699111..dd650427795c 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -177,7 +177,6 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 {
 	unsigned int len;
 	int i;
-	blk64_t	blocks;
 	ext2_extent_handle_t	handle;
 	struct ext2_extent_info	info;
 	struct ext2fs_extent	extent;
@@ -221,12 +220,15 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 		return 1;
 	}
 
-	blocks = ext2fs_inode_data_blocks2(fs, inode);
-	if (blocks) {
-		if (inode->i_flags & EXT4_INLINE_DATA_FL)
+	if (ext2fs_is_fast_symlink(inode)) {
+		if (inode->i_size >= sizeof(inode->i_block))
+			return 0;
+
+		len = strnlen((char *)inode->i_block, sizeof(inode->i_block));
+		if (len == sizeof(inode->i_block))
 			return 0;
+	} else {
 		if ((inode->i_size >= fs->blocksize) ||
-		    (blocks != fs->blocksize >> 9) ||
 		    (inode->i_block[0] < fs->super->s_first_data_block) ||
 		    (inode->i_block[0] >= ext2fs_blocks_count(fs->super)))
 			return 0;
@@ -245,34 +247,6 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 		}
 		if (len == fs->blocksize)
 			return 0;
-	} else if (inode->i_flags & EXT4_INLINE_DATA_FL) {
-		char *inline_buf = NULL;
-		size_t inline_sz = 0;
-
-		if (ext2fs_inline_data_size(fs, ino, &inline_sz))
-			return 0;
-		if (inode->i_size != inline_sz)
-			return 0;
-		if (ext2fs_get_mem(inline_sz + 1, &inline_buf))
-			return 0;
-		i = 0;
-		if (ext2fs_inline_data_get(fs, ino, inode, inline_buf, NULL))
-			goto exit_inline;
-		inline_buf[inline_sz] = 0;
-		len = strnlen(inline_buf, inline_sz);
-		if (len != inline_sz)
-			goto exit_inline;
-		i = 1;
-exit_inline:
-		ext2fs_free_mem(&inline_buf);
-		return i;
-	} else {
-		if (inode->i_size >= sizeof(inode->i_block))
-			return 0;
-
-		len = strnlen((char *)inode->i_block, sizeof(inode->i_block));
-		if (len == sizeof(inode->i_block))
-			return 0;
 	}
 	if (len != inode->i_size)
 		if ((inode->i_flags & EXT4_ENCRYPT_FL) == 0)
@@ -1787,7 +1761,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			if (inode->i_flags & EXT4_INLINE_DATA_FL) {
 				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
-			} else if (ext2fs_inode_data_blocks(fs, inode) == 0) {
+			} else if (ext2fs_is_fast_symlink(inode)) {
 				ctx->fs_fast_symlinks_count++;
 				check_blocks(ctx, &pctx, block_buf);
 				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index af214106852f..3fd921679286 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -353,10 +353,11 @@ blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino,
 	ext2_extent_handle_t	handle = NULL;
 	errcode_t		err;
 
-	if (inode == NULL || ext2fs_inode_data_blocks2(fs, inode) == 0)
-		goto no_blocks;
-
-	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+	/* Make sure data stored in inode->i_block is neither fast symlink nor
+	 * inline data.
+	 */
+	if (inode == NULL || ext2fs_is_fast_symlink(inode) ||
+	    inode->i_flags & EXT4_INLINE_DATA_FL)
 		goto no_blocks;
 
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c18ea5f827ad..0106d705e12c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1603,6 +1603,7 @@ errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir, const char *name,
 /* symlink.c */
 errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 			 const char *name, const char *target);
+int ext2fs_is_fast_symlink(struct ext2_inode *inode);
 
 /* mmp.c */
 errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf);
diff --git a/lib/ext2fs/namei.c b/lib/ext2fs/namei.c
index 307aecc88d87..d485a7209772 100644
--- a/lib/ext2fs/namei.c
+++ b/lib/ext2fs/namei.c
@@ -50,7 +50,21 @@ static errcode_t follow_link(ext2_filsys fs, ext2_ino_t root, ext2_ino_t dir,
 	if (link_count++ >= EXT2FS_MAX_NESTED_LINKS)
 		return EXT2_ET_SYMLINK_LOOP;
 
-	if (ext2fs_inode_data_blocks(fs,&ei)) {
+	if (ext2fs_is_fast_symlink(&ei))
+		pathname = (char *)&(ei.i_block[0]);
+	else if (ei.i_flags & EXT4_INLINE_DATA_FL) {
+		retval = ext2fs_get_memzero(ei.i_size, &buffer);
+		if (retval)
+			return retval;
+
+		retval = ext2fs_inline_data_get(fs, inode,
+						&ei, buffer, NULL);
+		if (retval) {
+			ext2fs_free_mem(&buffer);
+			return retval;
+		}
+		pathname = buffer;
+	} else {
 		retval = ext2fs_bmap2(fs, inode, &ei, NULL, 0, 0, NULL, &blk);
 		if (retval)
 			return retval;
@@ -65,8 +79,8 @@ static errcode_t follow_link(ext2_filsys fs, ext2_ino_t root, ext2_ino_t dir,
 			return retval;
 		}
 		pathname = buffer;
-	} else
-		pathname = (char *)&(ei.i_block[0]);
+	}
+
 	retval = open_namei(fs, root, dir, pathname, ei.i_size, 1,
 			    link_count, buf, res_inode);
 	if (buffer)
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 2d05ee7b995b..4522045dd1ca 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -210,18 +210,24 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 			    struct ext2_inode_large *f, int hostorder,
 			    int bufsize)
 {
-	unsigned i, has_data_blocks, extra_isize, attr_magic;
-	int has_extents = 0;
-	int has_inline_data = 0;
-	int islnk = 0;
+	unsigned i, extra_isize, attr_magic;
+	int has_extents, has_inline_data, islnk, fast_symlink;
 	int inode_size;
 	__u32 *eaf, *eat;
 
-	if (hostorder && LINUX_S_ISLNK(f->i_mode))
-		islnk = 1;
+	/*
+	 * Note that t and f may point to the same address. That's why
+	 * if (hostorder) condition is executed before swab calls and
+	 * if (!hostorder) afterwards.
+	 */
+	if (hostorder) {
+		islnk = LINUX_S_ISLNK(f->i_mode);
+		fast_symlink = ext2fs_is_fast_symlink(EXT2_INODE(f));
+		has_extents = (f->i_flags & EXT4_EXTENTS_FL) != 0;
+		has_inline_data = (f->i_flags & EXT4_INLINE_DATA_FL) != 0;
+	}
+
 	t->i_mode = ext2fs_swab16(f->i_mode);
-	if (!hostorder && LINUX_S_ISLNK(t->i_mode))
-		islnk = 1;
 	t->i_uid = ext2fs_swab16(f->i_uid);
 	t->i_size = ext2fs_swab32(f->i_size);
 	t->i_atime = ext2fs_swab32(f->i_atime);
@@ -231,27 +237,21 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 	t->i_gid = ext2fs_swab16(f->i_gid);
 	t->i_links_count = ext2fs_swab16(f->i_links_count);
 	t->i_file_acl = ext2fs_swab32(f->i_file_acl);
-	if (hostorder)
-		has_data_blocks = ext2fs_inode_data_blocks(fs,
-					   (struct ext2_inode *) f);
 	t->i_blocks = ext2fs_swab32(f->i_blocks);
-	if (!hostorder)
-		has_data_blocks = ext2fs_inode_data_blocks(fs,
-					   (struct ext2_inode *) t);
-	if (hostorder && (f->i_flags & EXT4_EXTENTS_FL))
-		has_extents = 1;
-	if (hostorder && (f->i_flags & EXT4_INLINE_DATA_FL))
-		has_inline_data = 1;
 	t->i_flags = ext2fs_swab32(f->i_flags);
-	if (!hostorder && (t->i_flags & EXT4_EXTENTS_FL))
-		has_extents = 1;
-	if (!hostorder && (t->i_flags & EXT4_INLINE_DATA_FL))
-		has_inline_data = 1;
 	t->i_size_high = ext2fs_swab32(f->i_size_high);
+
+	if (!hostorder) {
+		islnk = LINUX_S_ISLNK(t->i_mode);
+		fast_symlink = ext2fs_is_fast_symlink(EXT2_INODE(t));
+		has_extents = (t->i_flags & EXT4_EXTENTS_FL) != 0;
+		has_inline_data = (t->i_flags & EXT4_INLINE_DATA_FL) != 0;
+	}
+
 	/*
 	 * Extent data and inline data are swapped on access, not here
 	 */
-	if (!has_extents && !has_inline_data && (!islnk || has_data_blocks)) {
+	if (!has_extents && !has_inline_data && (!islnk || !fast_symlink)) {
 		for (i = 0; i < EXT2_N_BLOCKS; i++)
 			t->i_block[i] = ext2fs_swab32(f->i_block[i]);
 	} else if (t != f) {
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index 0e6f9a9fd14e..271aa1ccc134 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -174,3 +174,14 @@ cleanup:
 		ext2fs_free_mem(&block_buf);
 	return retval;
 }
+
+/*
+ * Test whether an inode is a fast symlink.
+ *
+ * A fast symlink has its symlink data stored in inode->i_block.
+ */
+int ext2fs_is_fast_symlink(struct ext2_inode *inode)
+{
+	return LINUX_S_ISLNK(inode->i_mode) && EXT2_I_SIZE(inode) &&
+	       EXT2_I_SIZE(inode) < sizeof(inode->i_block);
+}
\ No newline at end of file
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index b5897685c466..ee7af419da71 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -863,8 +863,9 @@ static int op_readlink(const char *path, char *buf, size_t len)
 	len--;
 	if (inode.i_size < len)
 		len = inode.i_size;
-	if (ext2fs_inode_data_blocks2(fs, &inode) ||
-	    (inode.i_flags & EXT4_INLINE_DATA_FL)) {
+	if (ext2fs_is_fast_symlink(&inode))
+		memcpy(buf, (char *)inode.i_block, len);
+	else {
 		/* big/inline symlink */
 
 		err = ext2fs_file_open(fs, ino, 0, &file);
@@ -888,9 +889,7 @@ out2:
 			ret = translate_error(fs, ino, err);
 			goto out;
 		}
-	} else
-		/* inline symlink */
-		memcpy(buf, (char *)inode.i_block, len);
+	}
 	buf[len] = 0;
 
 	if (fs_writeable(fs)) {
-- 
2.13.2.725.g09c95d1e9-goog
