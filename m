From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/12] ext4: Simplify list handling in ext4_do_flush_completed_IO()
Date: Fri, 18 Jan 2013 13:00:41 +0100
Message-ID: <1358510446-19174-8-git-send-email-jack@suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab3ARMA6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 07:00:58 -0500
In-Reply-To: <1358510446-19174-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function splices i_completed_io_list to its private list first. From that
moment on we don't need any lock for working with io_end structures because all
io_end structure on the list are only our own. So we can remove the other two
lists in the function and free io_end immediately after we are done with it.

CC: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/page-io.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index a029017..3fb385c 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -160,14 +160,11 @@ void ext4_add_complete_io(ext4_io_end_t *io_end)
 static int ext4_do_flush_completed_IO(struct inode *inode)
 {
 	ext4_io_end_t *io;
-	struct list_head unwritten, complete, to_free;
+	struct list_head unwritten;
 	unsigned long flags;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	int err, ret = 0;
 
-	INIT_LIST_HEAD(&complete);
-	INIT_LIST_HEAD(&to_free);
-
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	dump_completed_IO(inode);
 	list_replace_init(&ei->i_completed_io_list, &unwritten);
@@ -181,20 +178,7 @@ static int ext4_do_flush_completed_IO(struct inode *inode)
 		err = ext4_end_io(io);
 		if (unlikely(!ret && err))
 			ret = err;
-
-		list_add_tail(&io->list, &complete);
-	}
-	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	while (!list_empty(&complete)) {
-		io = list_entry(complete.next, ext4_io_end_t, list);
 		io->flag &= ~EXT4_IO_END_UNWRITTEN;
-		list_move(&io->list, &to_free);
-	}
-	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
