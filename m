From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RESEND][PATCH 2/2 v2] ext4: let us fully support punching hole feature in fallocate
Date: Fri, 18 Jan 2013 15:16:21 +0800
Message-ID: <1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
References: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58175 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3ARHCk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 02:02:40 -0500
Received: by mail-pa0-f50.google.com with SMTP id hz10so1948614pad.37
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2013 23:02:39 -0800 (PST)
In-Reply-To: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After adding indirect punching hole feature, we need to enable it in fallocate.
For this purpose, some sanity checks need to be adjusted.  Currently we need to
check FALLOC_FL_PUNCH_HOLE flag before other sanity checks.

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5ae1674..76643fd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4397,13 +4397,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	struct ext4_map_blocks map;
 	unsigned int credits, blkbits = inode->i_blkbits;
 
-	/*
-	 * currently supporting (pre)allocate mode for extent-based
-	 * files _only_
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		return -EOPNOTSUPP;
