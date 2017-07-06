From: Miao Xie <miaoxie@huawei.com>
Subject: [PATCH 1/4] ext4: fix forgetten xattr lock protection in ext4_expand_extra_isize
Date: Fri, 7 Jul 2017 01:09:50 +0800
Message-ID: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <miaoxie@huawei.com>, <tytso@mit.edu>, <lixi@ddn.com>,
        <yi.zhang@huawei.com>, <adilger@dilger.ca>, <wshilong@ddn.com>,
        <sihara@ddn.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9358 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdGFIkd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jul 2017 04:40:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should avoid the contention between the i_extra_isize update and
the inline data insertion, so move the xattr trylock in front of
i_extra_isize update.

Signed-off-by: Miao Xie <miaoxie@huawei.com>
Reviewed-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/inode.c | 18 ++++++++++++++++--
 fs/ext4/xattr.c | 10 ----------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5cf82d0..4af3edc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5639,10 +5639,15 @@ static int ext4_expand_extra_isize(struct inode *inode,
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
+	int no_expand;
+	int error;
 
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
 		return 0;
 
+	if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
+		return 0;
+
 	raw_inode = ext4_raw_inode(&iloc);
 
 	header = IHDR(inode, raw_inode);
@@ -5654,12 +5659,21 @@ static int ext4_expand_extra_isize(struct inode *inode,
 		       EXT4_I(inode)->i_extra_isize, 0,
 		       new_extra_isize - EXT4_I(inode)->i_extra_isize);
 		EXT4_I(inode)->i_extra_isize = new_extra_isize;
+		ext4_write_unlock_xattr(inode, &no_expand);
 		return 0;
 	}
 
 	/* try to expand with EAs present */
-	return ext4_expand_extra_isize_ea(inode, new_extra_isize,
-					  raw_inode, handle);
+	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
+					   raw_inode, handle);
+	if (error) {
+		/*
+		 * Inode size expansion failed; don't try again
+		 */
+		no_expand = 1;
+	}
+	ext4_write_unlock_xattr(inode, &no_expand);
+	return error;
 }
 
 /*
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5d3c253..12ee5fb 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1472,10 +1472,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	int error = 0, tried_min_extra_isize = 0;
 	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
 	int isize_diff;	/* How much do we need to grow i_extra_isize */
-	int no_expand;
