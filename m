From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 1/2] ext2: clear uptodate flag on super block I/O error (v2)
Date: Tue, 17 Nov 2009 09:46:18 -0800
Message-ID: <20091117174647.315080808@vyatta.com>
References: <20091117174617.285298261@vyatta.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from suva.vyatta.com ([76.74.103.44]:37781 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbZKQSHt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Nov 2009 13:07:49 -0500
Received: from suva.vyatta.com (suva [127.0.0.1])
	by suva.vyatta.com (8.13.7/8.13.7) with ESMTP id nAHHlseI030045
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 09:47:54 -0800
Content-Disposition: inline; filename=ext2-uptodate.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a WARN backtrace in mark_buffer_dirty() that occurs during
unmount when a USB or floppy device is removed. 
The super block update from a previous operation has marked the buffer
as in error, and the flag has to be cleared before doing the update.
(Similar code already exists in ext4).

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
Patch against 2.6.32-rc7
Revised to handle both sync_fs and put_super updating superblock.


--- a/fs/ext2/super.c	2009-11-17 09:13:21.346375999 -0800
+++ b/fs/ext2/super.c	2009-11-17 09:14:12.177002522 -0800
@@ -1099,11 +1099,24 @@ static void ext2_commit_super (struct su
 
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
 {
+	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
+
+	if (buffer_write_io_error(sbh)) {
+		/*
+		 * This happens if USB or floppy device is yanked out.
+		 * Maybe user put device back in so warn and update again.
+		 */
+		printk(KERN_ERR
+		       "EXT2-fs: previous I/O error to superblock detected\n");
+		clear_buffer_write_io_error(sbh);
+		set_buffer_uptodate(sbh);
+	}
+
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
-	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
-	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
+	mark_buffer_dirty(sbh);
+	sync_dirty_buffer(sbh);
 	sb->s_dirt = 0;
 }
 

-- 

