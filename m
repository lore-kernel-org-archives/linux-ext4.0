From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/3 v2] ext4: let us fully support punching hole feature in fallocate
Date: Mon, 19 Nov 2012 20:55:17 +0800
Message-ID: <1353329718-2075-3-git-send-email-wenqing.lz@taobao.com>
References: <1353329718-2075-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40976 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2KSMmv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 07:42:51 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so430130pad.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 04:42:51 -0800 (PST)
In-Reply-To: <1353329718-2075-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After adding indirect punching hole feature, we need to enable it in fallocate.
For this purpose, some sanity checks need to be adjusted.  Currently we need to
check FALLOC_FL_PUNCH_HOLE flag before other sanity checks.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7011ac9..b43b3e9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4420,13 +4420,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	struct ext4_map_blocks map;
 	unsigned int credits, blkbits = inode->i_blkbits;
 
-	/*
-	 * currently supporting (pre)allocate mode for extent-based
-	 * files _only_
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		return -EOPNOTSUPP;
