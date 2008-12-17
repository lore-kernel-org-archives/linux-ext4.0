From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] [e2fsprogs] e2fsck: fix segmentation fault when block size
 is greater than 8192
Date: Wed, 17 Dec 2008 16:58:12 +0800
Message-ID: <4948BF24.3040601@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbYLQI7u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When I did fsck a filesystem with large blocksize(greater than 8192),
segmentation fault occured. The cause is the size of b_data array that is
defined as a fixed size in buffer_head structure.
  (File: e2fsck/jfs_user.h)
  struct buffer_head {
	char		b_data[8192];
	e2fsck_t	b_ctx;
	io_channel	b_io;
	int		b_size;
	blk_t		b_blocknr;
	int		b_dirty;
	int		b_uptodate;
	int		b_err;
  };

It is unreasonable, because if the blocksize is greater than 8192, b_data will
overflow and the other variable would be changed, then if we touch those
variable, segmentation fault occurs.

This patch fixes this bug.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 e2fsck/jfs_user.h |    2 +-
 e2fsck/journal.c  |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 0e4f951..f042218 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -15,7 +15,7 @@
 #include "e2fsck.h"
 
 struct buffer_head {
-	char		b_data[8192];
+	char *		b_data;
 	e2fsck_t	b_ctx;
 	io_channel 	b_io;
 	int	 	b_size;
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 10f5095..ca7a4c3 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -73,6 +73,12 @@ struct buffer_head *getblk(kdev_t kdev, blk_t blocknr, int blocksize)
 	if (!bh)
 		return NULL;
 
+	bh->b_data = e2fsck_allocate_memory(kdev->k_ctx, blocksize,
+						"block buffer b_data");
+	if (!bh->b_data) {
+		ext2fs_free_mem(&bh);
+		return NULL;
+	}
 #ifdef CONFIG_JBD_DEBUG
 	if (journal_enable_debug >= 3)
 		bh_count++;
@@ -163,6 +169,8 @@ void brelse(struct buffer_head *bh)
 		ll_rw_block(WRITE, 1, &bh);
 	jfs_debug(3, "freeing block %lu/%p (total %d)\n",
 		  (unsigned long) bh->b_blocknr, (void *) bh, --bh_count);
+	if (bh->b_data)
+		ext2fs_free_mem(&bh->b_data);
 	ext2fs_free_mem(&bh);
 }
 
-- 
1.5.4.rc3

