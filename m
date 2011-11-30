From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix ext4_end_io_dio() racing against fsync()
Date: Wed, 30 Nov 2011 15:53:48 -0500
Message-ID: <1322686428-17728-1-git-send-email-tytso@mit.edu>
Cc: curtw@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53951 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1K3Uxz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Nov 2011 15:53:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to make sure iocb->private is cleared *before* we put the
io_end structure on i_completed_io_list.  Otherwise fsync() could
potentially run on another CPU and free the iocb structure out from
under us.

Reported-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 848f436..d2c8663 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2781,10 +2781,11 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
  		  iocb->private, io_end->inode->i_ino, iocb, offset,
 		  size);
 
+	iocb->private = NULL;
+
 	/* if not aio dio with unwritten extents, just free io and return */
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		ext4_free_io_end(io_end);
-		iocb->private = NULL;
 out:
 		if (is_async)
 			aio_complete(iocb, ret, 0);
@@ -2807,7 +2808,6 @@ out:
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
 	/* queue the work to convert unwritten extents to written */
-	iocb->private = NULL;
 	queue_work(wq, &io_end->work);
 
 	/* XXX: probably should move into the real I/O completion handler */
-- 
1.7.4.1.22.gec8e1.dirty

