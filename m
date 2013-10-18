From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 24/25] misc: add fuse2fs, a FUSE server for e2fsprogs
Date: Fri, 18 Oct 2013 12:36:07 -0700
Message-ID: <20131018193607.GA6860@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045141.7339.44234.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18051 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab3JRTgZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 15:36:25 -0400
Content-Disposition: inline
In-Reply-To: <20131018045141.7339.44234.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since last month, I've removed a number of flush calls that didn't seem
necessary, and amended the inode removal function to release any associated EA
blocks.  The diff looks like this:

---
 misc/fuse2fs.c |   49 ++++++++-----------------------------------------
 1 file changed, 8 insertions(+), 41 deletions(-)

diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 09171a9..d1c00df 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -382,6 +382,10 @@ static void op_destroy(void *p)
 		err = ext2fs_set_gdt_csum(fs);
 		if (err)
 			translate_error(fs, 0, err);
+
+		err = ext2fs_flush2(fs, 0);
+		if (err)
+			translate_error(fs, 0, err);
 	}
 }
 
@@ -636,12 +640,6 @@ static int op_mknod(const char *path, mode_t mode, dev_t dev)
 
 	ext2fs_inode_alloc_stats2(fs, child, 1, 0);
 
-	err = ext2fs_flush2(fs, EXT2_FLAG_FLUSH_NO_SYNC);
-	if (err) {
-		ret = translate_error(fs, child, err);
-		goto out2;
-	}
-
 out2:
 	pthread_mutex_unlock(&ff->bfl);
 out:
@@ -854,18 +852,14 @@ static int remove_inode(struct fuse2fs *ff, ext2_ino_t ino)
 	if (inode.i_links_count)
 		goto out;
 
+	err = ext2fs_free_ext_attr(fs, ino, &inode);
+	if (err)
+		goto out;
 	if (ext2fs_inode_has_valid_blocks2(fs, (struct ext2_inode *)&inode))
 		ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
 				      release_blocks_proc, NULL);
 	ext2fs_inode_alloc_stats2(fs, ino, -1,
 				  LINUX_S_ISDIR(inode.i_mode));
-
-	err = ext2fs_flush2(fs, EXT2_FLAG_FLUSH_NO_SYNC);
-	if (err) {
-		ret = translate_error(fs, ino, err);
-		goto out;
-	}
-
 out:
 	return ret;
 }
@@ -1655,26 +1649,6 @@ out:
 	return got ? got : ret;
 }
 
-static int op_flush(const char *path, struct fuse_file_info *fp)
-{
-	struct fuse_context *ctxt = fuse_get_context();
-	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
-	ext2_filsys fs = ff->fs;
-	struct fuse2fs_file_handle *fh = (struct fuse2fs_file_handle *)fp->fh;
-	errcode_t err;
-	int ret = 0;
-
-	pthread_mutex_lock(&ff->bfl);
-	if (fs_writeable(fs) && fh->open_flags & EXT2_FILE_WRITE) {
-		err = ext2fs_flush2(fs, EXT2_FLAG_FLUSH_NO_SYNC);
-		if (err)
-			ret = translate_error(fs, fh->ino, err);
-	}
-	pthread_mutex_unlock(&ff->bfl);
-
-	return ret;
-}
-
 static int op_release(const char *path, struct fuse_file_info *fp)
 {
 	struct fuse_context *ctxt = fuse_get_context();
@@ -2219,12 +2193,6 @@ static int op_create(const char *path, mode_t mode, struct fuse_file_info *fp)
 
 	ext2fs_inode_alloc_stats2(fs, child, 1, 0);
 
-	err = ext2fs_flush2(fs, EXT2_FLAG_FLUSH_NO_SYNC);
-	if (err) {
-		ret = translate_error(fs, child, err);
-		goto out2;
-	}
