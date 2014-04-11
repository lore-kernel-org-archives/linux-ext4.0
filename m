From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] patch move-ext4_update_i_disksize-into-mpage_map_and_submit_extent
Date: Fri, 11 Apr 2014 10:35:57 -0400
Message-ID: <1397226957-9581-1-git-send-email-tytso@mit.edu>
Cc: pfonseca@mpi-sws.org, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52923 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbaDKOgJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2014 10:36:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---
 fs/ext4/ext4.h  | 17 -----------------
 fs/ext4/inode.c | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f1c65dc..66946aa 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2466,23 +2466,6 @@ static inline void ext4_update_i_disksize(struct inode *inode, loff_t newsize)
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
-/*
- * Update i_disksize after writeback has been started. Races with truncate
- * are avoided by checking i_size under i_data_sem.
- */
-static inline void ext4_wb_update_i_disksize(struct inode *inode, loff_t newsize)
-{
-	loff_t i_size;
-
-	down_write(&EXT4_I(inode)->i_data_sem);
-	i_size = i_size_read(inode);
-	if (newsize > i_size)
-		newsize = i_size;
-	if (newsize > EXT4_I(inode)->i_disksize)
-		EXT4_I(inode)->i_disksize = newsize;
-	up_write(&EXT4_I(inode)->i_data_sem);
-}
-
 struct ext4_group_info {
 	unsigned long   bb_state;
 	struct rb_root  bb_free_root;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7b93df9..f023f0c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2247,13 +2247,23 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 			return err;
 	} while (map->m_len);
 
-	/* Update on-disk size after IO is submitted */
+	/*
+	 * Update on-disk size after IO is submitted.  Races with
+	 * truncate are avoided by checking i_size under i_data_sem.
+	 */
 	disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT;
 	if (disksize > EXT4_I(inode)->i_disksize) {
 		int err2;
