From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/2 bigalloc] e2fsprogs: remove wrong EXT2FS_C2B in check_block_end
Date: Thu,  4 Aug 2011 11:48:02 +0800
Message-ID: <1312429682-16970-2-git-send-email-hao.bigrat@gmail.com>
References: <1312429682-16970-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>, Ted Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64824 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1HDDsr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 23:48:47 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so1253271pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 03 Aug 2011 20:48:47 -0700 (PDT)
In-Reply-To: <1312429682-16970-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The argument "save_blocks_count" and the block bitmap has the unit of cluster,
so it don't need EXT2FS_C2B to convert argument "i".

This patch is based on "next" branch of e2fsprogs.

Signed-off-by: Robin Dong <sanbai@taobao.com>
Cc: Ted Ts'o <tytso@mit.edu>
---
 e2fsck/pass5.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index f9d746c..bb2a4dd 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -763,12 +763,10 @@ static void check_block_end(e2fsck_t ctx)
 
 	/* Protect loop from wrap-around if end is maxed */
 	for (i = save_blocks_count + 1; i <= end && i > save_blocks_count; i++) {
-		if (!ext2fs_test_block_bitmap2(fs->block_map,
-					       EXT2FS_C2B(fs, i))) {
+		if (!ext2fs_test_block_bitmap2(fs->block_map, i)) {
 			if (fix_problem(ctx, PR_5_BLOCK_BMAP_PADDING, &pctx)) {
 				for (; i <= end; i++)
-					ext2fs_mark_block_bitmap2(fs->block_map,
-							EXT2FS_C2B(fs, i));
+					ext2fs_mark_block_bitmap2(fs->block_map, i);
 				ext2fs_mark_bb_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
-- 
1.7.3.2

