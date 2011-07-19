From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] e2fsck: fix error in computing blocks of the ending group
Date: Tue, 19 Jul 2011 23:46:51 +0800
Message-ID: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41609 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1GSPvE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 11:51:04 -0400
Received: by iwn6 with SMTP id 6so4183996iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 19 Jul 2011 08:51:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the blocks of a filesystem is a multiple of blocks_per_group,
blocks of the ending group is computed wrongly.  This patch computes
it by substracting blocks processed from blocks of the filesystem.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 e2fsck/pass5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index f9d746c..7c4e336 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -227,7 +227,7 @@ redo_counts:
 				if (group == (int)fs->group_desc_count - 1)
 					cmp_block =
 						EXT2FS_NUM_B2C(fs,
-		ext2fs_blocks_count(fs->super) % fs->super->s_blocks_per_group);
+					ext2fs_blocks_count(fs->super) - i);
 			}
 
 			bitmap = 0;
-- 
1.7.5.1

