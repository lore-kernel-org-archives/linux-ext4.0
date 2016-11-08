From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/11] ext2: Use iomap_zero_range() for zeroing truncated page in DAX path
Date: Tue,  8 Nov 2016 12:08:16 +0100
Message-ID: <1478603297-11793-11-git-send-email-jack@suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933011AbcKHLKk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Nov 2016 06:10:40 -0500
In-Reply-To: <1478603297-11793-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently the last user of ext2_get_blocks() for DAX inodes was
dax_truncate_page(). Convert that to iomap_zero_range() so that all DAX
IO uses the iomap path.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 41b8b44a391c..046b642f3585 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -850,6 +850,9 @@ struct iomap_ops ext2_iomap_ops = {
 	.iomap_begin		= ext2_iomap_begin,
 	.iomap_end		= ext2_iomap_end,
 };
+#else
+/* Define empty ops for !CONFIG_FS_DAX case to avoid ugly ifdefs */
+struct iomap_ops ext2_iomap_ops;
 #endif /* CONFIG_FS_DAX */
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
@@ -1293,9 +1296,11 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_dio_wait(inode);
 
-	if (IS_DAX(inode))
-		error = dax_truncate_page(inode, newsize, ext2_get_block);
-	else if (test_opt(inode->i_sb, NOBH))
+	if (IS_DAX(inode)) {
+		error = iomap_zero_range(inode, newsize,
+					 PAGE_ALIGN(newsize) - newsize, NULL,
+					 &ext2_iomap_ops);
+	} else if (test_opt(inode->i_sb, NOBH))
 		error = nobh_truncate_page(inode->i_mapping,
 				newsize, ext2_get_block);
 	else
-- 
2.6.6

