From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Remove plugging from ext4_file_write_iter()
Date: Tue, 27 Sep 2016 16:22:28 +0200
Message-ID: <1474986148-9683-3-git-send-email-jack@suse.cz>
References: <1474986148-9683-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48739 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933724AbcI0OWe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Sep 2016 10:22:34 -0400
In-Reply-To: <1474986148-9683-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

do_blockdev_direct_IO() takes care of properly plugging direct IO so
there's no need to plug again inside ext4_file_write_iter().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 7e110c1a649d..9c9b7ed08d3c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -92,7 +92,6 @@ static ssize_t
 ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
-	struct blk_plug plug;
 	int o_direct = iocb->ki_flags & IOCB_DIRECT;
 	int unaligned_aio = 0;
 	int overwrite = 0;
@@ -133,7 +132,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (o_direct) {
 		size_t length = iov_iter_count(from);
 		loff_t pos = iocb->ki_pos;
-		blk_start_plug(&plug);
 
 		/* check whether we do a DIO overwrite or not */
 		if (ext4_should_dioread_nolock(inode) && !unaligned_aio &&
@@ -170,8 +168,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (ret > 0)
 		ret = generic_write_sync(iocb, ret);
-	if (o_direct)
-		blk_finish_plug(&plug);
 
 	return ret;
 
-- 
2.6.6

