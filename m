From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: retry failed direct IO allocations
Date: Fri, 02 Oct 2009 17:39:11 -0500
Message-ID: <4AC6810F.9020600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbZJBWjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Oct 2009 18:39:10 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n92MdEtH024918
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 18:39:14 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n92MdBJY008057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 18:39:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a 256M filesystem, doing this in a loop:

        xfs_io -F -f -d -c 'pwrite 0 64m' test
        rm -f test

eventually leads to ENOSPC.  (the xfs_io command does a
64m direct IO write to the file "test")

As with other block allocation callers, it looks like we need to
potentially retry the allocations on the initial ENOSPC.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4abd683..098c466 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3291,6 +3291,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	ssize_t ret;
 	int orphan = 0;
 	size_t count = iov_length(iov, nr_segs);
+	int retries = 0;
 
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
@@ -3313,9 +3314,12 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 		}
 	}
 
+retry:
 	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 				 ext4_get_block, NULL);
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
 
 	if (orphan) {
 		int err;

