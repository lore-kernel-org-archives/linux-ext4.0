From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Allow unlocked direct IO when pages are cached
Date: Tue, 27 Sep 2016 16:22:27 +0200
Message-ID: <1474986148-9683-2-git-send-email-jack@suse.cz>
References: <1474986148-9683-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48749 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933724AbcI0OWj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Sep 2016 10:22:39 -0400
In-Reply-To: <1474986148-9683-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we do not allow unlocked (meaning without inode_lock) direct
IO when the file has any pages cached. This check is not needed anymore
as we keep inode lock until ext4_direct_IO_write() and thus can happily
writeback and evict any pages conflicting with current direct IO write.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 261ac3734c58..7e110c1a649d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -91,7 +91,6 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter *from, loff_t pos)
 static ssize_t
 ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct blk_plug plug;
 	int o_direct = iocb->ki_flags & IOCB_DIRECT;
@@ -138,7 +137,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 		/* check whether we do a DIO overwrite or not */
 		if (ext4_should_dioread_nolock(inode) && !unaligned_aio &&
-		    !file->f_mapping->nrpages && pos + length <= i_size_read(inode)) {
+		    pos + length <= i_size_read(inode)) {
 			struct ext4_map_blocks map;
 			unsigned int blkbits = inode->i_blkbits;
 			int err, len;
-- 
2.6.6

