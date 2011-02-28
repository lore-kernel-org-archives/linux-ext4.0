From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: optimize ext4_bio_write_page() when no extent conversion is needed
Date: Mon, 28 Feb 2011 13:13:03 -0500
Message-ID: <1298916783-31621-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37710 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab1B1SNJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 13:13:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If no extent conversion is required, wake up any processes waiting for
the page's writeback to be complete and free the ext4_io_end structure
directly in ext4_end_bio() instead of dropping it on the linked list
(which requires taking a spinlock to queue and dequeue the io_end
structure), and waiting for the workqueue to do this work.

This removes an extra scheduling delay before process waiting for an
fsync() to complete gets woken up, and it also reduces the CPU
overhead for a random write workload.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/page-io.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index d5c391f..0cfd03e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -259,6 +259,11 @@ static void ext4_end_bio(struct bio *bio, int error)
 			     bi_sector >> (inode->i_blkbits - 9));
 	}
 
+	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		ext4_free_io_end(io_end);
+		return;
+	}
+
 	/* Add the io_end to per-inode completed io list*/
 	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
 	list_add_tail(&io_end->list, &EXT4_I(inode)->i_completed_io_list);
-- 
1.7.3.1

