From: Ashish Samant <ashish.samant@oracle.com>
Subject: [PATCH] ext4: Fix return value for direct io reads at or beyond eof
Date: Mon, 12 Feb 2018 13:18:02 -0800
Message-ID: <1518470282-7948-1-git-send-email-ashish.samant@oracle.com>
Cc: ashish.samant@oracle.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50636 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754006AbeBLVSx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Feb 2018 16:18:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CLH954158152
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 21:18:53 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2g3j7y85yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 21:18:52 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1CLI9Y1020348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 21:18:09 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1CLI8HM024689
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 21:18:09 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, an unaligned dio read at eof on ext4 returns EINVAL from
do_blockdev_direct_IO. However this unaligned dio read at eof could be due
to previous short read and we should return zero.

Fix this by checking for this condition in ext4_direct_IO_read()
and returning zero, if true.

Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 534a913..8b3dbc0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3806,7 +3806,7 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = mapping->host;
 	size_t count = iov_iter_count(iter);
-	ssize_t ret;
+	ssize_t ret = 0;
 
 	/*
 	 * Shared inode_lock is enough for us - it protects against concurrent
@@ -3814,6 +3814,8 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	 * we are protected against page writeback as well.
 	 */
 	inode_lock_shared(inode);
+	if (iocb->ki_pos >= i_size_read(inode))
+		goto out_unlock;
 	ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,
 					   iocb->ki_pos + count - 1);
 	if (ret)
-- 
1.9.1
