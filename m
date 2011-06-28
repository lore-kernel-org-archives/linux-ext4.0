From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2] ext4: quiet 'unused variables' compiling warnings
Date: Tue, 28 Jun 2011 09:28:45 +0800
Message-ID: <1309224525-23875-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39167 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab1F1B3Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 21:29:16 -0400
Received: by iyb12 with SMTP id 12so4538745iyb.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:29:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Unused variables was deleted.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    2 --
 fs/ext4/mballoc.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f815cc8..94940aa 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3107,12 +3107,10 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 					      struct ext4_ext_path *path)
 {
 	struct ext4_extent *ex;
-	struct ext4_extent_header *eh;
 	int depth;
 	int err = 0;
 
 	depth = ext_depth(inode);
-	eh = path[depth].p_hdr;
 	ex = path[depth].p_ext;
 
 	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6ed859d..389386b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4666,12 +4666,10 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	struct ext4_buddy e4b;
 	int err = 0, ret, blk_free_count;
 	ext4_grpblk_t blocks_freed;
-	struct ext4_group_info *grp;
 
 	ext4_debug("Adding block(s) %llu-%llu\n", block, block + count - 1);
 
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
-	grp = ext4_get_group_info(sb, block_group);
 	/*
 	 * Check to see if we are freeing blocks across a group
 	 * boundary.
-- 
1.7.5.1

