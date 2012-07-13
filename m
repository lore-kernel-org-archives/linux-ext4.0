From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 09/12 v2] ext4: remove unused code from ext4_remove_blocks()
Date: Fri, 13 Jul 2012 15:19:12 +0200
Message-ID: <1342185555-21146-9-git-send-email-lczerner@redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162970Ab2GMNTv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jul 2012 09:19:51 -0400
In-Reply-To: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The "head removal" branch in the condition is never used in any code
path in ext4 since the function only caller ext4_ext_rm_leaf() will make
sure that the extent is properly split before removing blocks. Note that
there is a bug in this branch anyway.

This commit removes the unused code completely and makes use of
ext4_error() instead of printk if dubious range is provided.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b3300eb..455257f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2339,23 +2339,10 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 			*partial_cluster = EXT4_B2C(sbi, pblk);
 		else
 			*partial_cluster = 0;
-	} else if (from == le32_to_cpu(ex->ee_block)
-		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
-		/* head removal */
-		ext4_lblk_t num;
-		ext4_fsblk_t start;
-
-		num = to - from;
-		start = ext4_ext_pblock(ex);
-
-		ext_debug("free first %u blocks starting %llu\n", num, start);
-		ext4_free_blocks(handle, inode, NULL, start, num, flags);
