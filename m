From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH v2] ext4: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Tue, 28 Aug 2012 21:39:40 +0800
Message-ID: <CAPgLHd_3++6=n+4qbimZprbgfn83ps3j+Fe543OZBr61DVs=vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55521 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2H1Njl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Aug 2012 09:39:41 -0400
Received: by qaas11 with SMTP id s11so2642589qaa.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Aug 2012 06:39:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ext4/mballoc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8eae947..926f3a0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2195,12 +2195,11 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)];
 	i = group & (EXT4_DESC_PER_BLOCK(sb) - 1);
 
-	meta_group_info[i] = kmem_cache_alloc(cachep, GFP_KERNEL);
+	meta_group_info[i] = kmem_cache_zalloc(cachep, GFP_KERNEL);
 	if (meta_group_info[i] == NULL) {
 		ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
 		goto exit_group_info;
 	}
-	memset(meta_group_info[i], 0, kmem_cache_size(cachep));
 	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 		&(meta_group_info[i]->bb_state));
 
@@ -4008,7 +4007,6 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	ext4_get_group_no_and_offset(sb, goal, &group, &block);
 
 	/* set up allocation goals */
-	memset(ac, 0, sizeof(struct ext4_allocation_context));
 	ac->ac_b_ex.fe_logical = ar->logical & ~(sbi->s_cluster_ratio - 1);
 	ac->ac_status = AC_STATUS_CONTINUE;
 	ac->ac_sb = sb;
@@ -4291,7 +4289,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		}
 	}
 
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
+	ac = kmem_cache_zalloc(ext4_ac_cachep, GFP_NOFS);
 	if (!ac) {
 		ar->len = 0;
 		*errp = -ENOMEM;


