From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 26/28] ext4: Use direct_IO_no_locking in ext4 dio read.
Date: Tue,  2 Mar 2010 13:18:43 -0500
Message-ID: <1267553925-6308-27-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Jiaying Zhang <jiayingz@google.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43043 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab0CBSSy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:54 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ae7adf2..576bbe2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3440,7 +3440,14 @@ static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+	if (rw == READ && ext4_should_dioread_nolock(inode))
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
-- 
1.6.6.1.1.g974db.dirty

