From: Wang shilong <wangshilong1991@gmail.com>
Subject: [PATCH] Ext4: use 'unlikely' to improve the efficiency of the kernel
Date: Wed, 12 Jan 2011 18:39:50 +0800
Message-ID: <1294828790-3455-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org,
	Wang shilong <wangshilong1991@gmail.com>,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:64412 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3ALD3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2013 22:29:55 -0500
Received: by mail-yh0-f49.google.com with SMTP id f43so452514yha.8
        for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2013 19:29:55 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Since 'sb_getblk' seldomly return NULL,it will be better
to use 'unlikely' to check it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext4/resize.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 7ea6cbb..2ef10e1 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -309,7 +309,7 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 	int err;
 
 	bh = sb_getblk(sb, blk);
-	if (!bh)
+	if (unlikely(!bh))
 		return ERR_PTR(-EIO);
 	if ((err = ext4_journal_get_write_access(handle, bh))) {
 		brelse(bh);
@@ -386,7 +386,7 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 			return err;
 
 		bh = sb_getblk(sb, flex_gd->groups[group].block_bitmap);
-		if (!bh)
+		if (unlikely(!bh))
 			return -EIO;
 
 		err = ext4_journal_get_write_access(handle, bh);
@@ -461,7 +461,7 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 				goto out;
 
 			gdb = sb_getblk(sb, block);
-			if (!gdb) {
+			if (unlikely(!gdb)) {
 				err = -EIO;
 				goto out;
 			}
@@ -983,7 +983,7 @@ static void update_backups(struct super_block *sb,
 			break;
 
 		bh = sb_getblk(sb, group * bpg + blk_off);
-		if (!bh) {
+		if (unlikely(!bh)) {
 			err = -EIO;
 			break;
 		}
@@ -1074,7 +1074,7 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 static struct buffer_head *ext4_get_bitmap(struct super_block *sb, __u64 block)
 {
 	struct buffer_head *bh = sb_getblk(sb, block);
-	if (!bh)
+	if (unlikely(!bh))
 		return NULL;
 
 	if (bitmap_uptodate(bh))
-- 
1.7.11.7

