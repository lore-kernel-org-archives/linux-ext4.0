From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/4] ext4: do not copy gdt blocks for groups which do not have super when resizing
Date: Mon, 30 Jan 2012 00:01:03 +0800
Message-ID: <1327852866-4448-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53480 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2CVNla (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 09:41:30 -0400
Received: by yhmm54 with SMTP id m54so1716019yhm.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 06:41:29 -0700 (PDT)
In-Reply-To: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no need to copy gdt blocks for groups which do not have super
in resizing code, so this patch let resize code skip the groups.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 59fa0be..9a6fb74 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -449,6 +449,9 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 		gdblocks = ext4_bg_num_gdb(sb, group);
 		start = ext4_group_first_block_no(sb, group);
 
+		if (!ext4_bg_has_super(sb, group))
+			goto handle_itb;
+
 		/* Copy all of the GDT blocks into the backup in this group */
 		for (j = 0, block = start + 1; j < gdblocks; j++, block++) {
 			struct buffer_head *gdb;
@@ -491,6 +494,7 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 				goto out;
 		}
 
+handle_itb:
 		/* Initialize group tables of the grop @group */
 		if (!(bg_flags[i] & EXT4_BG_INODE_ZEROED))
 			goto handle_bb;
-- 
1.7.5.1

