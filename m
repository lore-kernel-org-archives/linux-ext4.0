From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 1/3] Ext2: remove the overhead check about sb in the function
 ext2_new_blocks
Date: Wed, 06 Feb 2013 12:01:17 -0800
Message-ID: <5112B68D.3080108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:63854 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3BFD6p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2013 22:58:45 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so397051dak.11
        for <linux-ext4@vger.kernel.org>; Tue, 05 Feb 2013 19:58:45 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

It can be guranteed that inode->i_sb should not be null in vfs.
So here the check about it is overhead.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
fs/ext2/balloc.c | 4 ----
1 file changed, 4 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 1c36139..22993a0 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1239,10 +1239,6 @@ ext2_fsblk_t ext2_new_blocks(struct inode *inode, ext2_fsblk_t goal,

*errp = -ENOSPC;
sb = inode->i_sb;
- if (!sb) {
- printk("ext2_new_blocks: nonexistent device");
- return 0;
- }

/*
* Check quota for allocation of this block.
-- 
1.7.11.7

