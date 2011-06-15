From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4:quiet 'unsed variables' compiling warnings.
Date: Wed, 15 Jun 2011 11:27:00 +0800
Message-ID: <1308108420-13799-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45680 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab1FOD12 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 23:27:28 -0400
Received: by pvg12 with SMTP id 12so3453pvg.19
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jun 2011 20:27:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Delete unused variables.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    2 --
 fs/ext4/mballoc.c |    5 +----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5199bac..a33bf11 100644
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
index 859f2ae..fece8c2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2860,7 +2860,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 {
 	int bsbits, max;
 	ext4_lblk_t end;
-	loff_t size, orig_size, start_off;
+	loff_t size, start_off;
 	ext4_lblk_t start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_prealloc_space *pa;
@@ -2892,7 +2892,6 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	size = size << bsbits;
 	if (size < i_size_read(ac->ac_inode))
 		size = i_size_read(ac->ac_inode);
-	orig_size = size;
 
 	/* max size of free chunks */
 	max = 2 << bsbits;
@@ -4666,12 +4665,10 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
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

