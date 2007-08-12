From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Clean up libext2fs by byte swapping iff WORDS_BIGENDIAN
Date: Sun, 12 Aug 2007 12:57:19 -0400
Message-ID: <1186937842710-git-send-email-tytso@mit.edu>
References: <20070809214254.GB5438@thunk.org>
 <1186937841369-git-send-email-tytso@mit.edu>
 <11869378411811-git-send-email-tytso@mit.edu>
 <11869378412404-git-send-email-tytso@mit.edu>
 <11869378412289-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46653 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbXHLQ6g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 12:58:36 -0400
In-Reply-To: <11869378412289-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We don't need byte swapping to be a run-time option; it can just be a
compile-time option instead.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/bmap.c      |   28 ++++++-----------
 lib/ext2fs/closefs.c   |   77 ++++++++++++++++++++---------------------------
 lib/ext2fs/dirblock.c  |   40 +++++++------------------
 lib/ext2fs/ext_attr.c  |   24 ++++++---------
 lib/ext2fs/ind_block.c |   20 +++++-------
 lib/ext2fs/inode.c     |   52 +++++++++++++------------------
 lib/ext2fs/openfs.c    |   23 +++++++-------
 7 files changed, 105 insertions(+), 159 deletions(-)

diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index e840044..1dd562d 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -51,10 +51,8 @@ static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags,
 
 	if (flags & BMAP_SET) {
 		b = *ret_blk;
-#ifdef EXT2FS_ENABLE_SWAPFS
-		if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-		    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
-			b = ext2fs_swab32(b);
+#ifdef WORDS_BIGENDIAN
+		b = ext2fs_swab32(b);
 #endif
 		((blk_t *) block_buf)[nr] = b;
 		return io_channel_write_blk(fs->io, ind, 1, block_buf);
@@ -62,10 +60,8 @@ static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags,
 
 	b = ((blk_t *) block_buf)[nr];
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-	    (fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
-		b = ext2fs_swab32(b);
+#ifdef WORDS_BIGENDIAN
+	b = ext2fs_swab32(b);
 #endif
 
 	if (!b && (flags & BMAP_ALLOC)) {
@@ -75,13 +71,11 @@ static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags,
 		if (retval)
 			return retval;
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-		if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-		    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
-			((blk_t *) block_buf)[nr] = ext2fs_swab32(b);
-		else
+#ifdef WORDS_BIGENDIAN
+		((blk_t *) block_buf)[nr] = ext2fs_swab32(b);
+#else
+		((blk_t *) block_buf)[nr] = b;
 #endif
-			((blk_t *) block_buf)[nr] = b;
 
 		retval = io_channel_write_blk(fs->io, ind, 1, block_buf);
 		if (retval)
@@ -167,10 +161,8 @@ errcode_t ext2fs_bmap(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 	if (block < EXT2_NDIR_BLOCKS) {
 		if (bmap_flags & BMAP_SET) {
 			b = *phys_blk;
-#ifdef EXT2FS_ENABLE_SWAPFS
-			if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-			    (fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
-				b = ext2fs_swab32(b);
+#ifdef WORDS_BIGENDIAN
+			b = ext2fs_swab32(b);
 #endif
 			inode_bmap(inode, block) = b;
 			inode_dirty++;
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 474e00e..c570256 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -191,12 +191,11 @@ static errcode_t write_backup_super(ext2_filsys fs, dgrp_t group,
 	
 	if (sgrp > ((1 << 16) - 1))
 		sgrp = (1 << 16) - 1;
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
-		super_shadow->s_block_group_nr = ext2fs_swab16(sgrp);
-	else
+#ifdef WORDS_BIGENDIAN
+	super_shadow->s_block_group_nr = ext2fs_swab16(sgrp);
+#else
+	fs->super->s_block_group_nr = sgrp;
 #endif
-		fs->super->s_block_group_nr = sgrp;
 
 	return io_channel_write_blk(fs->io, group_block, -SUPERBLOCK_SIZE, 
 				    super_shadow);
@@ -220,29 +219,23 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 
 	fs->super->s_wtime = fs->now ? fs->now : time(NULL);
 	fs->super->s_block_group_nr = 0;
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-		retval = EXT2_ET_NO_MEMORY;
-		retval = ext2fs_get_mem(SUPERBLOCK_SIZE, &super_shadow);
-		if (retval)
-			goto errout;
-		retval = ext2fs_get_mem((size_t)(fs->blocksize *
-						 fs->desc_blocks),
-					&group_shadow);
-		if (retval)
-			goto errout;
-		memset(group_shadow, 0, (size_t) fs->blocksize *
-		       fs->desc_blocks);
-
-		/* swap the group descriptors */
-		for (j=0, s=fs->group_desc, t=group_shadow;
-		     j < fs->group_desc_count; j++, t++, s++) {
-			*t = *s;
-			ext2fs_swap_group_desc(t);
-		}
-	} else {
-		super_shadow = fs->super;
-		group_shadow = fs->group_desc;
+#ifdef WORDS_BIGENDIAN
+	retval = EXT2_ET_NO_MEMORY;
+	retval = ext2fs_get_mem(SUPERBLOCK_SIZE, &super_shadow);
+	if (retval)
+		goto errout;
+	retval = ext2fs_get_mem((size_t)(fs->blocksize * fs->desc_blocks),
+				&group_shadow);
+	if (retval)
+		goto errout;
+	memset(group_shadow, 0, (size_t) fs->blocksize *
+	       fs->desc_blocks);
+	
+	/* swap the group descriptors */
+	for (j=0, s=fs->group_desc, t=group_shadow;
+	     j < fs->group_desc_count; j++, t++, s++) {
+		*t = *s;
+		ext2fs_swap_group_desc(t);
 	}
 #else
 	super_shadow = fs->super;
@@ -255,11 +248,9 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 	 * we write out the backup superblocks.)
 	 */
 	fs->super->s_state &= ~EXT2_VALID_FS;
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-		*super_shadow = *fs->super;
-		ext2fs_swap_super(super_shadow);
-	}
+#ifdef WORDS_BIGENDIAN
+	*super_shadow = *fs->super;
+	ext2fs_swap_super(super_shadow);
 #endif
 
 	/*
@@ -333,11 +324,9 @@ write_primary_superblock_only:
 
 	fs->super->s_block_group_nr = 0;
 	fs->super->s_state = fs_state;
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-		*super_shadow = *fs->super;
-		ext2fs_swap_super(super_shadow);
-	}
+#ifdef WORDS_BIGENDIAN
+	*super_shadow = *fs->super;
+	ext2fs_swap_super(super_shadow);
 #endif
 
 	retval = io_channel_flush(fs->io);
@@ -350,12 +339,12 @@ write_primary_superblock_only:
 	retval = io_channel_flush(fs->io);
 errout:
 	fs->super->s_state = fs_state;
-	if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-		if (super_shadow)
-			ext2fs_free_mem(&super_shadow);
-		if (group_shadow)
-			ext2fs_free_mem(&group_shadow);
-	}
+#ifdef WORDS_BIGENDIAN
+	if (super_shadow)
+		ext2fs_free_mem(&super_shadow);
+	if (group_shadow)
+		ext2fs_free_mem(&group_shadow);
+#endif
 	return retval;
 }
 
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index ebfc72c..fb20fa0 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -25,26 +25,21 @@ errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 	errcode_t	retval;
 	char		*p, *end;
 	struct ext2_dir_entry *dirent;
-	unsigned int	name_len, rec_len, do_swap;
+	unsigned int	name_len, rec_len;
 	
 
  	retval = io_channel_read_blk(fs->io, block, 1, buf);
 	if (retval)
 		return retval;
-#ifdef EXT2FS_ENABLE_SWAPFS
-	do_swap = (fs->flags & (EXT2_FLAG_SWAP_BYTES|
-				EXT2_FLAG_SWAP_BYTES_READ)) != 0;
-#endif
+
 	p = (char *) buf;
 	end = (char *) buf + fs->blocksize;
 	while (p < end-8) {
 		dirent = (struct ext2_dir_entry *) p;
-#ifdef EXT2FS_ENABLE_SWAPFS
-		if (do_swap) {
-			dirent->inode = ext2fs_swab32(dirent->inode);
-			dirent->rec_len = ext2fs_swab16(dirent->rec_len);
-			dirent->name_len = ext2fs_swab16(dirent->name_len);
-		}
+#ifdef WORDS_BIGENDIAN
+		dirent->inode = ext2fs_swab32(dirent->inode);
+		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
+		dirent->name_len = ext2fs_swab16(dirent->name_len);
 #endif
 		name_len = dirent->name_len;
 #ifdef WORDS_BIGENDIAN
@@ -73,22 +68,12 @@ errcode_t ext2fs_read_dir_block(ext2_filsys fs, blk_t block,
 errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 				  void *inbuf, int flags EXT2FS_ATTR((unused)))
 {
-#ifdef EXT2FS_ENABLE_SWAPFS
-	int		do_swap = 0;
+#ifdef WORDS_BIGENDIAN
 	errcode_t	retval;
 	char		*p, *end;
 	char		*buf = 0;
 	struct ext2_dir_entry *dirent;
 
-	if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-	    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
-		do_swap = 1;
-
-#ifndef WORDS_BIGENDIAN
-	if (!do_swap)
-		return io_channel_write_blk(fs->io, block, 1, (char *) inbuf);
-#endif
-
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval)
 		return retval;
@@ -103,15 +88,12 @@ errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 			return (EXT2_ET_DIR_CORRUPTED);
 		}
 		p += dirent->rec_len;
-		if (do_swap) {
-			dirent->inode = ext2fs_swab32(dirent->inode);
-			dirent->rec_len = ext2fs_swab16(dirent->rec_len);
-			dirent->name_len = ext2fs_swab16(dirent->name_len);
-		}
-#ifdef WORDS_BIGENDIAN 
+		dirent->inode = ext2fs_swab32(dirent->inode);
+		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
+		dirent->name_len = ext2fs_swab16(dirent->name_len);
+
 		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
 			dirent->name_len = ext2fs_swab16(dirent->name_len);
-#endif
 	}
  	retval = io_channel_write_blk(fs->io, block, 1, buf);
 	ext2fs_free_mem(&buf);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 08211c3..ee5fe16 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -30,10 +30,8 @@ errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf)
  	retval = io_channel_read_blk(fs->io, block, 1, buf);
 	if (retval)
 		return retval;
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if ((fs->flags & (EXT2_FLAG_SWAP_BYTES|
-			  EXT2_FLAG_SWAP_BYTES_READ)) != 0)
-		ext2fs_swap_ext_attr(buf, buf, fs->blocksize, 1);
+#ifdef WORDS_BIGENDIAN
+	ext2fs_swap_ext_attr(buf, buf, fs->blocksize, 1);
 #endif
 	return 0;
 }
@@ -44,17 +42,15 @@ errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block, void *inbuf)
 	char		*write_buf;
 	char		*buf = NULL;
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-	    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE)) {
-		retval = ext2fs_get_mem(fs->blocksize, &buf);
-		if (retval)
-			return retval;
-		write_buf = buf;
-		ext2fs_swap_ext_attr(buf, inbuf, fs->blocksize, 1);
-	} else
+#ifdef WORDS_BIGENDIAN
+	retval = ext2fs_get_mem(fs->blocksize, &buf);
+	if (retval)
+		return retval;
+	write_buf = buf;
+	ext2fs_swap_ext_attr(buf, inbuf, fs->blocksize, 1);
+#else
+	write_buf = (char *) inbuf;
 #endif
-		write_buf = (char *) inbuf;
  	retval = io_channel_write_blk(fs->io, block, 1, write_buf);
 	if (buf)
 		ext2fs_free_mem(&buf);
diff --git a/lib/ext2fs/ind_block.c b/lib/ext2fs/ind_block.c
index 3519048..9baa37f 100644
--- a/lib/ext2fs/ind_block.c
+++ b/lib/ext2fs/ind_block.c
@@ -34,12 +34,10 @@ errcode_t ext2fs_read_ind_block(ext2_filsys fs, blk_t blk, void *buf)
 		if (retval)
 			return retval;
 	}
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_READ)) {
-		block_nr = (blk_t *) buf;
-		for (i = 0; i < limit; i++, block_nr++)
-			*block_nr = ext2fs_swab32(*block_nr);
-	}
+#ifdef WORDS_BIGENDIAN
+	block_nr = (blk_t *) buf;
+	for (i = 0; i < limit; i++, block_nr++)
+		*block_nr = ext2fs_swab32(*block_nr);
 #endif
 	return 0;
 }
@@ -53,12 +51,10 @@ errcode_t ext2fs_write_ind_block(ext2_filsys fs, blk_t blk, void *buf)
 	if (fs->flags & EXT2_FLAG_IMAGE_FILE)
 		return 0;
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_WRITE)) {
-		block_nr = (blk_t *) buf;
-		for (i = 0; i < limit; i++, block_nr++)
-			*block_nr = ext2fs_swab32(*block_nr);
-	}
+#ifdef WORDS_BIGENDIAN
+	block_nr = (blk_t *) buf;
+	for (i = 0; i < limit; i++, block_nr++)
+		*block_nr = ext2fs_swab32(*block_nr);
 #endif
 	return io_channel_write_blk(fs->io, blk, 1, buf);
 }
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 49d012c..6f24b61 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -453,32 +453,28 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 		scan->ptr += scan->inode_size - extra_bytes;
 		scan->bytes_left -= scan->inode_size - extra_bytes;
 
-#ifdef EXT2FS_ENABLE_SWAPFS
+#ifdef WORDS_BIGENDIAN
 		memset(inode, 0, bufsize);
-		if ((scan->fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-		    (scan->fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
-			ext2fs_swap_inode_full(scan->fs, 
-				(struct ext2_inode_large *) inode,
-				(struct ext2_inode_large *) scan->temp_buffer, 
-				0, bufsize);
-		else
+		ext2fs_swap_inode_full(scan->fs, 
+			       (struct ext2_inode_large *) inode,
+			       (struct ext2_inode_large *) scan->temp_buffer, 
+			       0, bufsize);
+#else
+		*inode = *((struct ext2_inode *) scan->temp_buffer);
 #endif
-			*inode = *((struct ext2_inode *) scan->temp_buffer);
 		if (scan->scan_flags & EXT2_SF_BAD_EXTRA_BYTES)
 			retval = EXT2_ET_BAD_BLOCK_IN_INODE_TABLE;
 		scan->scan_flags &= ~EXT2_SF_BAD_EXTRA_BYTES;
 	} else {
-#ifdef EXT2FS_ENABLE_SWAPFS
+#ifdef WORDS_BIGENDIAN
 		memset(inode, 0, bufsize);
-		if ((scan->fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-		    (scan->fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
-			ext2fs_swap_inode_full(scan->fs, 
+		ext2fs_swap_inode_full(scan->fs, 
 				(struct ext2_inode_large *) inode,
 				(struct ext2_inode_large *) scan->ptr,
 				0, bufsize);
-		else
+#else
+		memcpy(inode, scan->ptr, bufsize);
 #endif
-			memcpy(inode, scan->ptr, bufsize);
 		scan->ptr += scan->inode_size;
 		scan->bytes_left -= scan->inode_size;
 		if (scan->scan_flags & EXT2_SF_BAD_INODE_BLK)
@@ -583,12 +579,10 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		block_nr++;
 	}
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-	    (fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
-		ext2fs_swap_inode_full(fs, (struct ext2_inode_large *) inode, 
-				       (struct ext2_inode_large *) inode, 
-				       0, bufsize);
+#ifdef WORDS_BIGENDIAN
+	ext2fs_swap_inode_full(fs, (struct ext2_inode_large *) inode, 
+			       (struct ext2_inode_large *) inode, 
+			       0, bufsize);
 #endif
 
 	/* Update the inode cache */
@@ -657,16 +651,14 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		w_inode = &temp_inode;
 	memset(w_inode, 0, length);
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
-	    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
-		ext2fs_swap_inode_full(fs, w_inode, 
-				       (struct ext2_inode_large *) inode, 
-				       1, bufsize);
-	else
+#ifdef WORDS_BIGENDIAN
+	ext2fs_swap_inode_full(fs, w_inode, 
+			       (struct ext2_inode_large *) inode, 
+			       1, bufsize);
+#else
+	memcpy(w_inode, inode, bufsize);
 #endif
-		memcpy(w_inode, inode, bufsize);
-	
+
 	group = (ino - 1) / EXT2_INODES_PER_GROUP(fs->super);
 	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(fs->super)) *
 		EXT2_INODE_SIZE(fs->super);
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 55cc077..f2790ad 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -178,12 +178,13 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	if (fs->orig_super)
 		memcpy(fs->orig_super, fs->super, SUPERBLOCK_SIZE);
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if ((fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC)) ||
-	    (fs->flags & EXT2_FLAG_SWAP_BYTES)) {
-		fs->flags |= EXT2_FLAG_SWAP_BYTES;
-
-		ext2fs_swap_super(fs->super);
+#ifdef WORDS_BIGENDIAN
+	fs->flags |= EXT2_FLAG_SWAP_BYTES;
+	ext2fs_swap_super(fs->super);
+#else
+	if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
+		retval = EXT2_ET_UNIMPLEMENTED;
+		goto cleanup;
 	}
 #endif
 	
@@ -289,12 +290,10 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		retval = io_channel_read_blk(fs->io, blk, 1, dest);
 		if (retval)
 			goto cleanup;
-#ifdef EXT2FS_ENABLE_SWAPFS
-		if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
-			gdp = (struct ext2_group_desc *) dest;
-			for (j=0; j < groups_per_block; j++)
-				ext2fs_swap_group_desc(gdp++);
-		}
+#ifdef WORDS_BIGENDIAN
+		gdp = (struct ext2_group_desc *) dest;
+		for (j=0; j < groups_per_block; j++)
+			ext2fs_swap_group_desc(gdp++);
 #endif
 		dest += fs->blocksize;
 	}
-- 
1.5.3.rc4.67.gf9286
