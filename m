From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Fix oops in ext2_get_block() called from ext2_quota_write()
Date: Tue,  3 Dec 2013 12:57:05 +0100
Message-ID: <1386071825-10915-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab3LCL5M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 06:57:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2_quota_write() doesn't properly setup bh it passes to
ext2_get_block() and thus we hit assertion BUG_ON(maxblocks == 0) in
ext2_get_blocks() (or we could actually ask for mapping arbitrary number
of blocks depending on whatever value was on stack).

Fix ext2_quota_write() to properly fill in number of blocks to map.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c | 1 +
 1 file changed, 1 insertion(+)

  I plan to send this patch to Linus soon.

								Honza

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 288534920fe5..20d6697bd638 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1493,6 +1493,7 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 				sb->s_blocksize - offset : towrite;
 
 		tmp_bh.b_state = 0;
+		tmp_bh.b_size = sb->s_blocksize;
 		err = ext2_get_block(inode, blk, &tmp_bh, 1);
 		if (err < 0)
 			goto out;
-- 
1.8.1.4

