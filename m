From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCH] ext4: Flush any pending end_io requests before O_direct read on dioread_nolock
Date: Thu, 18 Aug 2011 18:28:45 -0700 (PDT)
Message-ID: <20110819012845.7A4A32012F@ruihe2.smo.corp.google.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:47250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1HSB2s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Aug 2011 21:28:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a race between ext4 buffer write and direct_IO read with
dioread_nolock mount option enabled. The problem is that we clear
PageWriteback flag during end_io time but will do
uninitialized-to-initialized extent conversion later with dioread_nolock.
If an O_direct read request comes in during this period, ext4 will return
zero instead of the recently written data.

This patch checks whether there are any pending uninitialized-to-initialized
extent conversion requests before doing O_direct read to close the race.
Note that this is just a bandaid fix. The fundamental issue is that we
clear PageWriteback flag before we really complete an IO, which is
problem-prone. To fix the fundamental issue, we may need to implement an
extent tree cache that we can use to look up pending to-be-converted extents.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
---
 fs/ext4/indirect.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 6c27111..ca90d73 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -800,12 +800,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	if (rw == READ && ext4_should_dioread_nolock(inode))
+	if (rw == READ && ext4_should_dioread_nolock(inode)) {
+		if (unlikely(!list_empty(&ei->i_completed_io_list))) {
+			mutex_lock(&inode->i_mutex);
+			ext4_flush_completed_IO(inode);
+			mutex_unlock(&inode->i_mutex);
+		}
 		ret = __blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 				 ext4_get_block, NULL, NULL, 0);
-	else {
+	} else {
 		ret = blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
-- 
1.7.3.1

