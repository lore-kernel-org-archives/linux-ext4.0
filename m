From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] ext4: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Mon, 27 Aug 2012 12:40:16 +0800
Message-ID: <CAPgLHd8oRK5qre9FEa6gGv68CWa8iUKnwROLMBJZ+hA-=kvvNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62738 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2H0EkR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Aug 2012 00:40:17 -0400
Received: by qcro28 with SMTP id o28so2314343qcr.19
        for <linux-ext4@vger.kernel.org>; Sun, 26 Aug 2012 21:40:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ext4/mballoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8eae947..6bc21a2 100644
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
 

