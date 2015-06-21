From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: call sync_blockdev() before invalidate_bdev() in put_super()
Date: Sat, 20 Jun 2015 22:50:55 -0400
Message-ID: <1434855055-22756-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46887 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbbFUCu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Jun 2015 22:50:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Normally all of the buffers will have been forced out to disk before
we call invalidate_bdev(), but there will be some cases, where a file
system operation was aborted due to an ext4_error(), where there may
still be some dirty buffers in the buffer cache for the device.  So
try to force them out to memory before calling invalidate_bdev().

This fixes a warning triggered by generic/081:

WARNING: CPU: 1 PID: 3473 at /usr/projects/linux/ext4/fs/block_dev.c:56 __blkdev_put+0xb5/0x16f()

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fdac076..2858ac0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -828,6 +828,7 @@ static void ext4_put_super(struct super_block *sb)
 		dump_orphan_list(sb, sbi);
 	J_ASSERT(list_empty(&sbi->s_orphan));
 
+	sync_blockdev(sb->s_bdev);
 	invalidate_bdev(sb->s_bdev);
 	if (sbi->journal_bdev && sbi->journal_bdev != sb->s_bdev) {
 		/*
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
