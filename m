From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] e2fsck: fix quota accounting to use cluster units
Date: Sun, 2 Apr 2017 12:57:05 -0400
Message-ID: <20170402165705.GA8705@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:32983 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbdDBQzx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Apr 2017 12:55:53 -0400
Received: by mail-qt0-f193.google.com with SMTP id r45so16225688qte.0
        for <linux-ext4@vger.kernel.org>; Sun, 02 Apr 2017 09:55:53 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The quota accounting code in e2fsck's pass 1 and pass 3 uses block units
rather than cluster units when recording the allocated space consumed by
files and directories.  In pass 1, this causes a large undercount of
actual quota results and test failures for xfstests generic/383, /384,
/385, and /386 on bigalloc file systems.  In pass 3, this results in
quota accounting errors when the lost+found directory is either extended
or recreated on a bigalloc file system.

Use clusters rather than blocks when accounting for allocated space,
and correct a related header comment in the quota code.

Note that pass 1b also contains call sites for quota_data_sub() that
also need to be addressed.  However, it appears that more than just
unit conversion may be needed, so that will be left to a future patch.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 e2fsck/pass1.c        | 3 ++-
 e2fsck/pass3.c        | 5 +++--
 lib/support/quotaio.h | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 1714897..188cc56 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3174,7 +3174,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	if (ino != quota_type2inum(PRJQUOTA, fs->super) &&
 	    (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INODE(ctx->fs->super))) {
 		quota_data_add(ctx->qctx, (struct ext2_inode_large *) inode,
-			       ino, pb.num_blocks * fs->blocksize);
+			       ino,
+			       pb.num_blocks * EXT2_CLUSTER_SIZE(fs->super));
 		quota_data_inodes(ctx->qctx, (struct ext2_inode_large *) inode,
 				  ino, +1);
 	}
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 44203ca..4d9430b 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -578,7 +578,7 @@ link_error:
 	ext2fs_icount_store(ctx->inode_count, ino, 2);
 	ext2fs_icount_store(ctx->inode_link_info, ino, 2);
 	ctx->lost_and_found = ino;
-	quota_data_add(ctx->qctx, &inode, ino, fs->blocksize);
+	quota_data_add(ctx->qctx, &inode, ino, EXT2_CLUSTER_SIZE(fs->super));
 	quota_data_inodes(ctx->qctx, &inode, ino, +1);
 #if 0
 	printf("/lost+found created; inode #%lu\n", ino);
@@ -899,7 +899,8 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	if (retval)
 		return retval;
 	ext2fs_iblk_add_blocks(fs, EXT2_INODE(&inode), es.newblocks);
-	quota_data_add(ctx->qctx, &inode, dir, es.newblocks * fs->blocksize);
+	quota_data_add(ctx->qctx, &inode, dir,
+		       es.newblocks * EXT2_CLUSTER_SIZE(fs->super));
 
 	e2fsck_write_inode_full(ctx, dir, EXT2_INODE(&inode),
 				sizeof(inode), "expand_directory");
diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
index 486c2a5..f89536e 100644
--- a/lib/support/quotaio.h
+++ b/lib/support/quotaio.h
@@ -12,7 +12,7 @@
  *
  *	quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
  *	{
- *		quota_compute_usage(qctx, QUOTA_ALL_BIT);
+ *		quota_compute_usage(qctx);
  *		AND/OR
  *		quota_data_add/quota_data_sub/quota_data_inodes();
  *	}
-- 
2.1.4
