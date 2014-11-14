From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4: cleanup GFP flags inside resize path V2
Date: Fri, 14 Nov 2014 13:40:39 +0400
Message-ID: <1415958040-4393-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, cmm@us.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:26550 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbaKNJlA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Nov 2014 04:41:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We must use GFP_NOFS instead GFP_KERNEL inside ext4_mb_add_groupinfo because resize-path
call  it inside journal transaction. Call trace:
ioctl
 ->ext4_group_add
   ->journal_start
   ->ext4_setup_new_descs
     ->ext4_mb_add_groupinfo -> GFP_KERNEL
   ->ext4_flex_group_add
     ->ext4_update_super
       ->ext4_calculate_overhead  -> GFP_KERNEL
   ->journal_stop

Changes from V1:
 - Fix up gfp flags for ext4_calculate_overhead

ext4_update_super

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/mballoc.c |    6 +++---
 fs/ext4/super.c   |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

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
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2c9e686..5f6cab8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3310,7 +3310,7 @@ int ext4_calculate_overhead(struct super_block *sb)
 	struct ext4_super_block *es = sbi->s_es;
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 	ext4_fsblk_t overhead = 0;
-	char *buf = (char *) get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *) get_zeroed_page(GFP_NOFS);
 
 	if (!buf)
 		return -ENOMEM;
-- 
1.7.1

