From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: remove quota allocation when ext4_mb_new_blocks fails
Date: Fri, 30 May 2008 11:28:16 +0800
Message-ID: <483F7450.7060004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53051 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbYE3Day (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 23:30:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Quota allocation is not removed When ext4_mb_new_blocks
calls kmem_cache_alloc failed.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/mballoc.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6180ebc..2411db6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4043,8 +4043,9 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (!ac) {
+		ar->len = 0;
 		*errp = -ENOMEM;
-		return 0;
+		goto out1;
 	}
 
 	ext4_mb_poll_new_transaction(sb, handle);
@@ -4052,7 +4053,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	*errp = ext4_mb_initialize_context(ac, ar);
 	if (*errp) {
 		ar->len = 0;
-		goto out;
+		goto out2;
 	}
 
 	ac->ac_op = EXT4_MB_HISTORY_PREALLOC;
@@ -4100,11 +4101,12 @@ repeat:
 
 	ext4_mb_release_context(ac);
 
-out:
+out2:
+	kmem_cache_free(ext4_ac_cachep, ac);
+out1:
 	if (ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
 
-	kmem_cache_free(ext4_ac_cachep, ac);
 	return block;
 }
 static void ext4_mb_poll_new_transaction(struct super_block *sb,
-- 
1.5.4.5
