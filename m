From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH] ext3: prevent reread after write IO error
Date: Thu, 14 Jan 2010 15:12:09 +0900
Message-ID: <4B4EB5B9.4020809@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@suse.de>, dle-develop@lists.sourceforge.net,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51941 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0ANGa0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 01:30:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes the similar bug fixed by commit 95450f5a.

If a directory is modified, its data block is journaled as metadata
and finally written back to the right place.  Now, we assume a
transient write erorr happens on that writeback.  Uptodate flag of
the buffer is cleared by write error, so next access on the buffer
causes a reread from disk.  This means it breaks the filesystems
consistency.

To prevent old directory data from being reread, this patch set
uptodate flag again in the case of after write error before issuing
the read operation.  The write error on the directory's data block
is detected at the time of journal checkpointing or discarded if a
rewrite by another modification succeeds, so no problem.

I tested this patch by using fault injection approach.

By the way, I think the right fix is to keep uptodate flag on write
error, but it gives a big impact.  We have to confirm whether
over 200 buffer_uptodate's are used for real uptodate check or write
error check.  For now, I adopt the quick-fix solution.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/ext3/inode.c |   13 +++++++++++++
 fs/ext3/namei.c |   15 ++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 455e6e6..17c7a5f 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1077,10 +1077,23 @@ struct buffer_head *ext3_bread(handle_t *handle, struct inode *inode,
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
+
+	/*
+	 * uptodate flag may have been cleared by a previous (transient)
+	 * write IO error.  In this case, we don't want to re-read its
+	 * old on-disk data.  Actually the buffer has the latest data,
+	 * so set uptodate flag again.
+	 */
+	if (buffer_write_io_error(bh)) {
+		set_buffer_uptodate(bh);
+		return bh;
+	}
+
 	ll_rw_block(READ_META, 1, &bh);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
+
 	put_bh(bh);
 	*err = -EIO;
 	return NULL;
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 7b0e44f..2f18797 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -909,7 +909,20 @@ restart:
 				num++;
 				bh = ext3_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
-				if (bh)
+				if (!bh || buffer_uptodate(bh))
+					continue;
+
+				/*
+				 * uptodate flag may have been cleared by a
+				 * previous (transient) write IO error.  In
+				 * this case, we don't want to re-read its
+				 * old on-disk data.  Actually the buffer
+				 * has the latest data, so set uptodate flag
+				 * again.
+				 */
+				if (buffer_write_io_error(bh))
+					set_buffer_uptodate(bh);
+				else
 					ll_rw_block(READ_META, 1, &bh);
 			}
 		}
-- 
1.6.0.3

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


