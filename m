From: Jan Kara <jack@suse.cz>
Subject: [PATCH] e2fsprogs: Handle rec_len correctly for 64KB blocksize (fwd)
Date: Tue, 6 Nov 2007 14:38:21 +0100
Message-ID: <20071106133821.GC23689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:40371 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751000AbXKFNiY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 08:38:24 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Wrote wrong mailing list address so I'm resending it to a correct one.

----- Forwarded message from Jan Kara <jack@suse.cz> -----

From: Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Cc: ext4-devel@vger.kernel.org
Subject: [PATCH] e2fsprogs: Handle rec_len correctly for 64KB blocksize

  Hello Ted,

  it seems attached patch still did not get your attention. It makes
e2fsprogs properly handle filesystems with 64KB block size. Could you put
it into e2fsprogs git? Thanks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

Subject: Support for 64KB blocksize in ext2-4 directories.

When block size is 64KB, we have to take care that rec_len does not overflow.
Kernel stores 0xffff in case 0x10000 should be stored - perform appropriate
conversion when reading from / writing to disk.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index fb20fa0..628bf93 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -38,9 +38,9 @@ errcode_t ext2fs_read_dir_block2(ext2_fi
 		dirent = (struct ext2_dir_entry *) p;
 #ifdef WORDS_BIGENDIAN
 		dirent->inode = ext2fs_swab32(dirent->inode);
-		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
 		dirent->name_len = ext2fs_swab16(dirent->name_len);
 #endif
+		dirent->rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 		name_len = dirent->name_len;
 #ifdef WORDS_BIGENDIAN
 		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
@@ -68,12 +68,15 @@ errcode_t ext2fs_read_dir_block(ext2_fil
 errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 				  void *inbuf, int flags EXT2FS_ATTR((unused)))
 {
-#ifdef WORDS_BIGENDIAN
 	errcode_t	retval;
 	char		*p, *end;
 	char		*buf = 0;
 	struct ext2_dir_entry *dirent;
 
+#ifndef WORDS_BIGENDIAN
+	if (fs->blocksize < EXT2_MAX_REC_LEN)
+		goto just_write;
+#endif
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval)
 		return retval;
@@ -89,7 +92,7 @@ errcode_t ext2fs_write_dir_block2(ext2_f
 		}
 		p += dirent->rec_len;
 		dirent->inode = ext2fs_swab32(dirent->inode);
-		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
+		dirent->rec_len = ext2fs_rec_len_to_disk(dirent->rec_len);
 		dirent->name_len = ext2fs_swab16(dirent->name_len);
 
 		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
@@ -98,9 +101,8 @@ errcode_t ext2fs_write_dir_block2(ext2_f
  	retval = io_channel_write_blk(fs->io, block, 1, buf);
 	ext2fs_free_mem(&buf);
 	return retval;
-#else
+just_write:
  	return io_channel_write_blk(fs->io, block, 1, (char *) inbuf);
-#endif
 }
 
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..2041f0f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -717,6 +717,32 @@ struct ext2_dir_entry_2 {
 #define EXT2_DIR_ROUND			(EXT2_DIR_PAD - 1)
 #define EXT2_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT2_DIR_ROUND) & \
 					 ~EXT2_DIR_ROUND)
+#define EXT2_MAX_REC_LEN		((1<<16)-1)
+
+static inline unsigned ext2fs_rec_len_from_disk(unsigned len)
+{
+#ifdef WORDS_BIGENDIAN
+	len = ext2fs_swab16(dlen);
+#endif
+	if (len == EXT2_MAX_REC_LEN)
+		return 1 << 16;
+	return len;
+}
+
+static inline unsigned ext2fs_rec_len_to_disk(unsigned len)
+{
+	if (len == (1 << 16))
+#ifdef WORDS_BIGENDIAN
+		return ext2fs_swab16(EXT2_MAX_REC_LEN);
+#else
+		return EXT2_MAX_REC_LEN;
+#endif
+#ifdef WORDS_BIGENDIAN
+	return ext2fs_swab_16(len);
+#else
+	return len;
+#endif
+}
 
 /*
  * This structure will be used for multiple mount protection. It will be
diff --git a/misc/e2image.c b/misc/e2image.c
index 1fbb267..4e2c9fb 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -345,10 +345,7 @@ static void scramble_dir_block(ext2_fils
 	end = buf + fs->blocksize;
 	for (p = buf; p < end-8; p += rec_len) {
 		dirent = (struct ext2_dir_entry_2 *) p;
-		rec_len = dirent->rec_len;
-#ifdef WORDS_BIGENDIAN
-		rec_len = ext2fs_swab16(rec_len);
-#endif
+		rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 #if 0
 		printf("rec_len = %d, name_len = %d\n", rec_len, dirent->name_len);
 #endif
@@ -358,9 +355,7 @@ static void scramble_dir_block(ext2_fils
 			       "bad rec_len (%d)\n", (unsigned long) blk, 
 			       rec_len);
 			rec_len = end - p;
-#ifdef WORDS_BIGENDIAN
-				dirent->rec_len = ext2fs_swab16(rec_len);
-#endif
+			dirent->rec_len = ext2fs_rec_len_to_disk(rec_len);
 			continue;
 		}
 		if (dirent->name_len + 8 > rec_len) {


----- End forwarded message -----
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
