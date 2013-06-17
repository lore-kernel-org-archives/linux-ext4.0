From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: remove while loop in mpage_map_and_submit_extent()
Date: Mon, 17 Jun 2013 09:58:07 -0400
Message-ID: <1371477488-17722-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58672 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab3FQN6M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jun 2013 09:58:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The while loop in mpage_map_and_submit_extent() is pointless; this
function is only called if mpd.map.m_len is non-zero, and at the end
of the while loop, mpage_map_and_submit_buffers sets mpd.map.m_len to
be zero on success.  (And on a failure, we return out of the while
loop anyway.)

Hence, the body of the while loop is guaranteed to execute once and
exactly once.  This also fixes a gcc warning complaining that err
might be left uninitialized.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 66 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2644679..0e61543 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2157,44 +2157,42 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 
 	mpd->io_submit.io_end->offset =
 				((loff_t)map->m_lblk) << inode->i_blkbits;
-	while (map->m_len) {
-		err = mpage_map_one_extent(handle, mpd);
-		if (err < 0) {
-			struct super_block *sb = inode->i_sb;
+	err = mpage_map_one_extent(handle, mpd);
+	if (err < 0) {
+		struct super_block *sb = inode->i_sb;
 
-			/*
-			 * Need to commit transaction to free blocks. Let upper
-			 * layers sort it out.
-			 */
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
-			return err;
-		}
 		/*
-		 * Update buffer state, submit mapped pages, and get us new
-		 * extent to map
+		 * Need to commit transaction to free blocks. Let upper
+		 * layers sort it out.
 		 */
-		err = mpage_map_and_submit_buffers(mpd);
-		if (err < 0)
-			return err;
+		if (err == -ENOSPC && ext4_count_free_clusters(sb))
+			return -ENOSPC;
+
+		if (!(EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED)) {
+			ext4_msg(sb, KERN_CRIT,
+				 "Delayed block allocation failed for "
+				 "inode %lu at logical offset %llu with"
+				 " max blocks %u with error %d",
+				 inode->i_ino,
+				 (unsigned long long)map->m_lblk,
+				 (unsigned)map->m_len, err);
+			ext4_msg(sb, KERN_CRIT,
+				 "This should not happen!! Data will "
+				 "be lost\n");
+			if (err == -ENOSPC)
+				ext4_print_free_blocks(inode);
+		}
+		/* invalidate all the pages */
+		mpage_release_unused_pages(mpd, true);
+		return err;
 	}
+	/*
+	 * Update buffer state, submit mapped pages, and get us new
+	 * extent to map
+	 */
+	err = mpage_map_and_submit_buffers(mpd);
+	if (err < 0)
+		return err;
 
 	/* Update on-disk size after IO is submitted */
 	disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT;
-- 
1.7.12.rc0.22.gcdd159b

