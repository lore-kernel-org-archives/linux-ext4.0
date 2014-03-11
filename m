From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 46/49] fuse2fs: implement fallocate
Date: Mon, 10 Mar 2014 23:58:55 -0700
Message-ID: <20140311065855.30585.32648.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaCKG7A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:59:00 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the (new) ext2fs_fallocate() to fallocate file space.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/fuse2fs.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)


diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index bfc9a91..04c2dea 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -3274,7 +3274,64 @@ out:
 static int fallocate_helper(struct fuse_file_info *fp, int mode, off_t offset,
 			    off_t len)
 {
-	return -EOPNOTSUPP;
+	struct fuse_context *ctxt = fuse_get_context();
+	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
+	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
+	ext2_filsys fs;
+	struct ext2_inode_large inode;
+	blk64_t start, end, x;
+	__u64 fsize;
+	errcode_t err;
+	int flags;
+	int ret = 0;
+
+	FUSE2FS_CHECK_CONTEXT(ff);
+	fs = ff->fs;
+	FUSE2FS_CHECK_MAGIC(fs, fh, FUSE2FS_FILE_MAGIC);
+	start = offset / fs->blocksize;
+	end = (offset + len - 1) / fs->blocksize;
+	dbg_printf("%s: ino=%d mode=0x%x start=%jd end=%llu\n", __func__,
+		   fh->ino, mode, offset / fs->blocksize, end);
+	if (!fs_can_allocate(ff, len / fs->blocksize))
+		return -ENOSPC;
+
+	memset(&inode, 0, sizeof(inode));
+	err = ext2fs_read_inode_full(fs, fh->ino, (struct ext2_inode *)&inode,
+				     sizeof(inode));
+	if (err)
+		return err;
+	fsize = EXT2_I_SIZE(&inode);
+
+	/* Allocate a bunch of blocks */
+	flags = (mode & FL_KEEP_SIZE_FLAG ? 0 :
+			EXT2_FALLOCATE_INIT_BEYOND_EOF);
+	err = ext2fs_fallocate(fs, flags, fh->ino,
+			       (struct ext2_inode *)&inode,
+			       start, end - start + 1);
+	if (err && err != EXT2_ET_BLOCK_ALLOC_FAIL)
+		return translate_error(fs, fh->ino, err);
+
+	/* Update i_size */
+	if (!(mode & FL_KEEP_SIZE_FLAG)) {
+		if (offset + len > fsize) {
+			err = ext2fs_inode_set_size(fs,
+						(struct ext2_inode *)&inode,
+						offset + len);
+			if (err)
+				return translate_error(fs, fh->ino, err);
+		}
+	}
+
+	err = update_mtime(fs, fh->ino, &inode);
+	if (err)
+		return err;
+
+	err = ext2fs_write_inode_full(fs, fh->ino, (struct ext2_inode *)&inode,
+				      sizeof(inode));
+	if (err)
+		return translate_error(fs, fh->ino, err);
+
+	return err;
 }
 
 static errcode_t clean_block_middle(ext2_filsys fs, ext2_ino_t ino,

