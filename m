From: Jan Kara <jack@suse.cz>
Subject: [PATCH 24/29] ext4: Remove wait for unwritten extent conversion from ext4_ext_truncate()
Date: Mon,  8 Apr 2013 23:32:29 +0200
Message-ID: <1365456754-29373-25-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936368Ab3DHVdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:07 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since PageWriteback bit is now cleared after extents are converted from
unwritten to written ones, we have full exclusion of writeback path from
truncate (truncate_inode_pages() waits for PageWriteback bits to get cleared
on all invalidated pages). Exclusion from DIO path is achieved by
inode_dio_wait() call in ext4_setattr(). So there's no need to wait for
extent convertion in ext4_ext_truncate() anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c |    6 ------
 fs/ext4/page-io.c |    9 ++++++++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ae22735..ca4ff71 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4256,12 +4256,6 @@ void ext4_ext_truncate(struct inode *inode)
 	int err = 0;
 
 	/*
-	 * finish any pending end_io work so we won't run the risk of
-	 * converting any truncated blocks to initialized later
-	 */
-	ext4_flush_unwritten_io(inode);
-
-	/*
 	 * probably first extent we're gonna free will be last in block
 	 */
 	err = ext4_writepage_trans_blocks(inode);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 2967794..2f0b943 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -145,7 +145,14 @@ static void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 		wake_up_all(ext4_ioend_wq(inode));
 }
 
-/* check a range of space and convert unwritten extents to written. */
+/*
+ * Check a range of space and convert unwritten extents to written. Note that
+ * we are protected from truncate touching same part of extent tree by the
+ * fact that truncate code waits for all DIO to finish (thus exclusion from
+ * direct IO is achieved) and also waits for PageWriteback bits. Thus we
+ * cannot get to ext4_ext_truncate() before all IOs overlapping that range are
+ * completed (happens from ext4_free_ioend()).
+ */
 static int ext4_end_io(ext4_io_end_t *io)
 {
 	struct inode *inode = io->inode;
-- 
1.7.1

