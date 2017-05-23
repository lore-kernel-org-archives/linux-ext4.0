From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] ext4: fix off-by-one error when writing back pages before dio read
Date: Mon, 22 May 2017 18:34:41 -0700
Message-ID: <20170523013441.49030-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34480 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbdEWBgz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 May 2017 21:36:55 -0400
Received: by mail-pf0-f196.google.com with SMTP id w69so23704004pfk.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 May 2017 18:36:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The 'lend' argument of filemap_write_and_wait_range() is inclusive, so
we need to subtract 1 from pos + count.

Note that 'count' is guaranteed to be nonzero since
ext4_file_read_iter() returns early when given a 0 count.

Fixes: 16c54688592c ("ext4: Allow parallel DIO reads")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7c6e715b4d2e..3080ea82dd6d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3710,7 +3710,7 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	 */
 	inode_lock_shared(inode);
 	ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,
-					   iocb->ki_pos + count);
+					   iocb->ki_pos + count - 1);
 	if (ret)
 		goto out_unlock;
 	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-- 
2.13.0.219.gdb65acc882-goog
