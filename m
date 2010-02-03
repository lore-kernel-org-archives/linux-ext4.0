From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: Do not allow retry alloc loop under open transaction
Date: Wed, 03 Feb 2010 21:27:31 +0300
Message-ID: <874olytbpe.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36940 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab0BCS3W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Feb 2010 13:29:22 -0500
Received: by bwz19 with SMTP id 19so339303bwz.28
        for <linux-ext4@vger.kernel.org>; Wed, 03 Feb 2010 10:29:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Some times we call ->write_begin() with opened journal
but write_begin() may internally call ext4_should_retry_alloc()
in case of ENOSPC, which result in deadlock.
This patch introduce new AOP_FLAG which should be tested on retry
alloc path.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h        |    5 +++++
 fs/ext4/inode.c       |    6 ++++--
 fs/ext4/move_extent.c |    2 +-
 include/linux/fs.h    |    1 +
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index af7b626..0efb224 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -792,6 +792,11 @@ struct ext4_inode_info {
 #define EXT4_DFL_CHECKINTERVAL		0	/* Don't use interval check */
 
 /*
+ * Address space flags.
+ */
+#define EXT4_AOP_FLAG_NORETRY	AOP_FLAG_LAST	/* Do not allow to fail in to
+						   retry alloc loop */
+/*
  * Behaviour when detecting errors
  */
 #define EXT4_ERRORS_CONTINUE		1	/* Continue execution */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c818972..2d3fe4d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1593,7 +1593,8 @@ retry:
 		}
 	}
 
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (!(flags & EXT4_AOP_FLAG_NORETRY) && ret == -ENOSPC &&
+		ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 out:
 	return ret;
@@ -3089,7 +3090,8 @@ retry:
 			ext4_truncate_failed_write(inode);
 	}
 
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (!(flags & EXT4_AOP_FLAG_NORETRY) &&
+		ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 out:
 	return ret;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 82c415b..f894382 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -796,7 +796,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	ext4_lblk_t orig_blk_offset;
 	long long offs = orig_page_offset << PAGE_CACHE_SHIFT;
 	unsigned long blocksize = orig_inode->i_sb->s_blocksize;
-	unsigned int w_flags = 0;
+	unsigned int w_flags = EXT4_AOP_FLAG_NORETRY;
 	unsigned int tmp_data_size, data_size, replaced_size;
 	void *fsdata;
 	int i, jblocks;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b1bcb27..6f68707 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -504,6 +504,7 @@ enum positive_aop_returns {
 #define AOP_FLAG_NOFS			0x0004 /* used by filesystem to direct
 						* helper code (eg buffer layer)
 						* to clear GFP_FS from alloc */
+#define AOP_FLAG_LAST			0x0008 /* First unused private flag */
 
 /*
  * oh the beauties of C type declarations.
-- 
1.6.3.3

