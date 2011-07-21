From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: let ext4_init_inode_table() handle errors right
Date: Thu, 21 Jul 2011 22:45:07 +0800
Message-ID: <1311259507-11716-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54208 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1GUOtX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jul 2011 10:49:23 -0400
Received: by pvh21 with SMTP id 21so405199pvh.19
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 07:49:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch lets ext4_init_inode_table() handle errors right.
ext4_init_inode_table() should down_write() alloc_sem which
has been up_write()ed and stop the started journal handle.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ialloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..9c63f27 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1287,7 +1287,7 @@ extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
 			   group, used_blks,
 			   ext4_itable_unused_count(sb, gdp));
 		ret = 1;
-		goto out;
+		goto err_out;
 	}
 
 	blk = ext4_inode_table(sb, gdp) + used_blks;
-- 
1.7.5.1

