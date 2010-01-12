From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCHv2 2/3] ext4: use direct_IO_no_locking in ext4 DIO read
Date: Tue, 12 Jan 2010 11:42:10 -0800 (PST)
Message-ID: <20100112194210.C27AC6E85C@peat.mtv.corp.google.com>
Cc: tytso@mit.edu, mrubin@google.com, akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:3065 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279Ab0ALTnM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 14:43:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

    ext4: Use direct_IO_no_locking in ext4 dio read.
    
    Signed-off-by: Jiaying Zhang <jiayingz@google.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9ee3550..44d2e19 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3395,7 +3395,15 @@ static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+	if (rw == READ && test_opt(inode->i_sb, DIOREAD_NOLOCK)
+			&& (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+		ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
+				 inode->i_sb->s_bdev, iov,
+				 offset, nr_segs,
+				 ext4_get_block, NULL);
+	else
+		ret = blockdev_direct_IO(rw, iocb, inode,
+				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 				 ext4_get_block, NULL);
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
