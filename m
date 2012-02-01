From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/2] ext4: ignore last group without enough space when resizing
Date: Wed,  1 Feb 2012 11:01:31 +0800
Message-ID: <1328065291-13607-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1328065291-13607-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org, dsd@laptop.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50373 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2DAMBK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Apr 2012 08:01:10 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so2911633iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Apr 2012 05:01:10 -0700 (PDT)
In-Reply-To: <1328065291-13607-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If last gtoup has no enough space for group tables, then we
just ignore it.

Reported-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 601fea1..7a961cc 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -199,7 +199,7 @@ static void free_flex_gd(struct ext4_new_flex_group_data *flex_gd)
  *
  * @sb: super block of fs to which the groups belongs
  */
-static void ext4_alloc_group_tables(struct super_block *sb,
+static int ext4_alloc_group_tables(struct super_block *sb,
 				struct ext4_new_flex_group_data *flex_gd,
 				int flexbg_size)
 {
@@ -224,6 +224,8 @@ static void ext4_alloc_group_tables(struct super_block *sb,
 	       (last_group & ~(flexbg_size - 1))));
 next_group:
 	group = group_data[0].group;
+	if (src_group >= group_data[0].group + flex_gd->count)
+		return -EINVAL;
 	start_blk = ext4_group_first_block_no(sb, src_group);
 	last_blk = start_blk + group_data[src_group - group].blocks_count;
 
@@ -233,7 +235,6 @@ next_group:
 
 	start_blk += overhead;
 
-	BUG_ON(src_group >= group_data[0].group + flex_gd->count);
 	/* We collect contiguous blocks as much as possible. */
 	src_group++;
 	for (; src_group <= last_group; src_group++)
@@ -298,6 +299,7 @@ next_group:
 			       group_data[i].free_blocks_count);
 		}
 	}
+	return 0;
 }
 
 static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
@@ -1668,7 +1670,11 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	 */
 	while (ext4_setup_next_flex_gd(sb, flex_gd, n_blocks_count,
 					      flexbg_size)) {
-		ext4_alloc_group_tables(sb, flex_gd, flexbg_size);
+		err = ext4_alloc_group_tables(sb, flex_gd, flexbg_size);
+		if (err == -EINVAL) {
+			err = 0;
+			break;
+		}
 		err = ext4_flex_group_add(sb, resize_inode, flex_gd);
 		if (unlikely(err))
 			break;
-- 
1.7.5.1

