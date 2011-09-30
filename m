From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] libext2fs: Always swab MMP block on BE machines
Date: Fri, 30 Sep 2011 12:41:26 -0700
Message-ID: <20110930194126.GU12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58269 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab1I3TlR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Sep 2011 15:41:17 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8UJHCoD021068
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 15:17:12 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8UJfGoT193176
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 15:41:16 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8UJfFJX007276
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 15:41:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The MMP code in libext2fs tries to gate MMP block swab'ing with this test:

#ifdef EXT2FS_ENABLE_SWAPFS
if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))

However, EXT2FS_ENABLE_SWAPFS never seems to be defined anywhere (all possible
#define's were cleaned out of e2fsprogs ages ago), and even if any still
existed, the field fs->super->s_magic is always in host byteorder, so the test
always fails.  So, we can change the #ifdef to WORDS_BIGENDIAN (which is
conditionally defined on BE platforms) and get rid of the broken if test.

(This fix came up while testing the metadata checksumming patchset)

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 lib/ext2fs/mmp.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index ed6ee42..91f4fb2 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -91,9 +91,8 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 	}
 
 	mmp_cmp = fs->mmp_cmp;
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
-		ext2fs_swap_mmp(mmp_cmp);
+#ifdef WORDS_BIGENDIAN
+	ext2fs_swap_mmp(mmp_cmp);
 #endif
 
 	if (buf != NULL && buf != fs->mmp_cmp)
@@ -122,18 +121,16 @@ errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 	    fs->super->s_mmp_block > ext2fs_blocks_count(fs->super))
 		return EXT2_ET_MMP_BAD_BLOCK;
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
-		ext2fs_swap_mmp(mmp_s);
+#ifdef WORDS_BIGENDIAN
+	ext2fs_swap_mmp(mmp_s);
 #endif
 
 	/* I was tempted to make this use O_DIRECT and the mmp_fd, but
 	 * this caused no end of grief, while leaving it as-is works. */
 	retval = io_channel_write_blk64(fs->io, mmp_blk, -fs->blocksize, buf);
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
-		ext2fs_swap_mmp(mmp_s);
+#ifdef WORDS_BIGENDIAN
+	ext2fs_swap_mmp(mmp_s);
 #endif
 
 	/* Make sure the block gets to disk quickly */
