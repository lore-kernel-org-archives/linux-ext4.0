From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 5/9] ext4: use kvzalloc and kvfree
Date: Thu, 13 May 2010 18:03:50 +0800
Message-ID: <1273745030-10297-1-git-send-email-xiaosuo@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Changli Gao <xiaosuo@gmail.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52015 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0EMKEG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 May 2010 06:04:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

use kvzalloc and kvfree

use kvzalloc and kvfree

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/ext4/super.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..822bd93 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -20,7 +20,6 @@
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/time.h>
-#include <linux/vmalloc.h>
 #include <linux/jbd2.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -679,10 +678,7 @@ static void ext4_put_super(struct super_block *sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
-	if (is_vmalloc_addr(sbi->s_flex_groups))
-		vfree(sbi->s_flex_groups);
-	else
-		kfree(sbi->s_flex_groups);
+	kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -1810,12 +1806,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
 			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
 	size = flex_group_count * sizeof(struct flex_groups);
-	sbi->s_flex_groups = kzalloc(size, GFP_KERNEL);
-	if (sbi->s_flex_groups == NULL) {
-		sbi->s_flex_groups = vmalloc(size);
-		if (sbi->s_flex_groups)
-			memset(sbi->s_flex_groups, 0, size);
-	}
+	sbi->s_flex_groups = kvzalloc(size);
 	if (sbi->s_flex_groups == NULL) {
 		ext4_msg(sb, KERN_ERR, "not enough memory for "
 				"%u flex groups", flex_group_count);
@@ -3060,12 +3051,8 @@ failed_mount_wq:
 		sbi->s_journal = NULL;
 	}
 failed_mount3:
-	if (sbi->s_flex_groups) {
-		if (is_vmalloc_addr(sbi->s_flex_groups))
-			vfree(sbi->s_flex_groups);
-		else
-			kfree(sbi->s_flex_groups);
-	}
+	if (sbi->s_flex_groups)
+		kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
