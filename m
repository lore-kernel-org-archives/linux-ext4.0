From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] ext4: fix up error handling for
 mpage_map_and_submit_extent()
Date: Fri, 21 Jun 2013 23:50:00 -0400
Message-ID: <20130622035000.GB4727@thunk.org>
References: <1371477488-17722-1-git-send-email-tytso@mit.edu>
 <1371477488-17722-2-git-send-email-tytso@mit.edu>
 <20130621163809.GO13932@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60193 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423471Ab3FVDuD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 23:50:03 -0400
Content-Disposition: inline
In-Reply-To: <20130621163809.GO13932@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since I dropped the earlier patch, I had to fix up this patch a wee
bit.

>From 1cd6c381602e86eb8c8064bcb212c9c8aeee062b Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 21 Jun 2013 23:49:09 -0400
Subject: [PATCH] ext4: fix up error handling for mpage_map_and_submit_extent()

The function mpage_released_unused_page() must only be called once;
otherwise the kernel will BUG() when the second call to
mpage_released_unused_page() tries to unlock the pages which had been
unlocked by the first call.

Also restructure the error handling so that we only give up on writing
the dirty pages in the case of ENOSPC where retrying the allocation
won't help.  Otherwise, a transient failure, such as a kmalloc()
failure in calling ext4_map_blocks() might cause us to give up on
those pages, leading to a scary message in /var/log/messages plus data
loss.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 52 ++++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bfc6d1e..e84ba3d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2153,7 +2153,8 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
  * guaranteed). After mapping we submit all mapped pages for IO.
  */
 static int mpage_map_and_submit_extent(handle_t *handle,
-				       struct mpage_da_data *mpd)
+				       struct mpage_da_data *mpd,
+				       bool *give_up_on_write)
 {
 	struct inode *inode = mpd->inode;
 	struct ext4_map_blocks *map = &mpd->map;
@@ -2167,29 +2168,30 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 		if (err < 0) {
 			struct super_block *sb = inode->i_sb;
 
+			if (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)
+				goto invalidate_dirty_pages;
 			/*
-			 * Need to commit transaction to free blocks. Let upper
-			 * layers sort it out.
+			 * Let the uper layers retry transient errors.
+			 * In the case of ENOSPC, if ext4_count_free_blocks()
+			 * is non-zero, a commit should free up blocks.
 			 */
-			if (err == -ENOSPC && ext4_count_free_clusters(sb))
-				return -ENOSPC;
-
-			if (!(EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)) {
-				ext4_msg(sb, KERN_CRIT,
-					 "Delayed block allocation failed for "
-					 "inode %lu at logical offset %llu with"
-					 " max blocks %u with error %d",
-					 inode->i_ino,
-					 (unsigned long long)map->m_lblk,
-					 (unsigned)map->m_len, err);
-				ext4_msg(sb, KERN_CRIT,
-					 "This should not happen!! Data will "
-					 "be lost\n");
-				if (err == -ENOSPC)
-					ext4_print_free_blocks(inode);
-			}
-			/* invalidate all the pages */
-			mpage_release_unused_pages(mpd, true);
+			if ((err == -ENOMEM) ||
+			    (err == -ENOSPC && ext4_count_free_clusters(sb)))
+				return err;
+			ext4_msg(sb, KERN_CRIT,
+				 "Delayed block allocation failed for "
+				 "inode %lu at logical offset %llu with"
+				 " max blocks %u with error %d",
+				 inode->i_ino,
+				 (unsigned long long)map->m_lblk,
+				 (unsigned)map->m_len, -err);
+			ext4_msg(sb, KERN_CRIT,
+				 "This should not happen!! Data will "
+				 "be lost\n");
+			if (err == -ENOSPC)
+				ext4_print_free_blocks(inode);
+		invalidate_dirty_pages:
+			*give_up_on_write = true;
 			return err;
 		}
 		/*
@@ -2377,6 +2379,7 @@ static int ext4_writepages(struct address_space *mapping,
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 	bool done;
 	struct blk_plug plug;
+	bool give_up_on_write = false;
 
 	trace_ext4_writepages(inode, wbc);
 
@@ -2494,7 +2497,8 @@ retry:
 		ret = mpage_prepare_extent_to_map(&mpd);
 		if (!ret) {
 			if (mpd.map.m_len)
-				ret = mpage_map_and_submit_extent(handle, &mpd);
+				ret = mpage_map_and_submit_extent(handle, &mpd,
+					&give_up_on_write);
 			else {
 				/*
 				 * We scanned the whole range (or exhausted
@@ -2509,7 +2513,7 @@ retry:
 		/* Submit prepared bio */
 		ext4_io_submit(&mpd.io_submit);
 		/* Unlock pages we didn't use */
-		mpage_release_unused_pages(&mpd, false);
+		mpage_release_unused_pages(&mpd, give_up_on_write);
 		/* Drop our io_end reference we got from init */
 		ext4_put_io_end(mpd.io_submit.io_end);
 
-- 
1.7.12.rc0.22.gcdd159b

