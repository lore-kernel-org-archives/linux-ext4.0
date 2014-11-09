From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: cleanup GFP flags inside resize path
Date: Sun,  9 Nov 2014 20:37:51 +0400
Message-ID: <1415551072-3949-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, cmm@us.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:15068 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaKIQiK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Nov 2014 11:38:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We must use GFP_NOFS instead GFP_KERNEL inside ext4_mb_add_groupinfo because resizing call
 it inside journal transaction. Call trace:
ioctl
 ->ext4_group_add
   ->journal_start
   ->ext4_setup_new_descs
     ->ext4_mb_add_groupinfo

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/mballoc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dbfe15c..654e70d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2385,7 +2385,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	if (group % EXT4_DESC_PER_BLOCK(sb) == 0) {
 		metalen = sizeof(*meta_group_info) <<
 			EXT4_DESC_PER_BLOCK_BITS(sb);
-		meta_group_info = kmalloc(metalen, GFP_KERNEL);
+		meta_group_info = kmalloc(metalen, GFP_NOFS);
 		if (meta_group_info == NULL) {
 			ext4_msg(sb, KERN_ERR, "can't allocate mem "
 				 "for a buddy group");
@@ -2399,7 +2399,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)];
 	i = group & (EXT4_DESC_PER_BLOCK(sb) - 1);
 
-	meta_group_info[i] = kmem_cache_zalloc(cachep, GFP_KERNEL);
+	meta_group_info[i] = kmem_cache_zalloc(cachep, GFP_NOFS);
 	if (meta_group_info[i] == NULL) {
 		ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
 		goto exit_group_info;
@@ -2428,7 +2428,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	{
 		struct buffer_head *bh;
 		meta_group_info[i]->bb_bitmap =
-			kmalloc(sb->s_blocksize, GFP_KERNEL);
+			kmalloc(sb->s_blocksize, GFP_NOFS);
 		BUG_ON(meta_group_info[i]->bb_bitmap == NULL);
 		bh = ext4_read_block_bitmap(sb, group);
 		BUG_ON(bh == NULL);
-- 
1.7.1

