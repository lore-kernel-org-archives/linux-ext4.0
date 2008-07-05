From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 23/52] ext4: fix ext4_init_block_bitmap() for metablock block group
Date: Sat,  5 Jul 2008 13:35:49 -0400
Message-ID: <1215279378-30504-24-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33126 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756076AbYGERge (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:34 -0400
In-Reply-To: <1215279378-30504-23-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akinobu Mita <akinobu.mita@gmail.com>

When meta_bg feature is enabled and s_first_meta_bg != 0,
ext4_init_block_bitmap() miscalculates the number of block used by
the group descriptor table (0 or 1 for metablock block group)

This patch fixes this by using ext4_bg_num_gdb()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Tweedie <sct@redhat.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Andreas Dilger <adilger@sun.com>
---
 fs/ext4/balloc.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 6dcbec9..1327ac3 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -121,12 +121,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
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
-- 
1.5.6.rc3.1.g36b7.dirty

