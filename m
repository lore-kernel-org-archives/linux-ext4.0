From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ext4: fix ext4_init_block_bitmap() for metablock block
	group
Date: Sun, 15 Jun 2008 23:24:56 +0900
Message-ID: <20080615142455.GA3502@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@MIT.EDU>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:64468 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbYFOO0R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jun 2008 10:26:17 -0400
Received: by wf-out-1314.google.com with SMTP id 27so4818735wfd.4
        for <linux-ext4@vger.kernel.org>; Sun, 15 Jun 2008 07:26:16 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When meta_bg feature is enabled and s_first_meta_bg != 0, 
ext4_init_block_bitmap() miscalculates the number of block used by
the group descriptor table (0 or 1 for metablock block group)

This patch fix it by using ext4_bg_num_gdb()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Tso <tytso@MIT.EDU>
---
 fs/ext4/balloc.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: 2.6-git/fs/ext4/balloc.c
===================================================================
--- 2.6-git.orig/fs/ext4/balloc.c
+++ 2.6-git/fs/ext4/balloc.c
@@ -121,12 +121,7 @@ unsigned ext4_init_block_bitmap(struct s
 				le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
 		}
 	} else { /* For META_BG_BLOCK_GROUPS */
-		int group_rel = (block_group -
-				 le32_to_cpu(sbi->s_es->s_first_meta_bg)) %
-				EXT4_DESC_PER_BLOCK(sb);
-		if (group_rel == 0 || group_rel == 1 ||
-		    (group_rel == EXT4_DESC_PER_BLOCK(sb) - 1))
-			bit_max += 1;
+		bit_max += ext4_bg_num_gdb(sb, block_group);
 	}
 
 	if (block_group == sbi->s_groups_count - 1) {
