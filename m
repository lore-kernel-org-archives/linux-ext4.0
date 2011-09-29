From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC PATCH V2 4/6] ext4: initialize delayed extent tree
Date: Thu, 29 Sep 2011 13:08:44 +0800
Message-ID: <1317272926-13303-5-git-send-email-xiaoqiangnk@gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: jack@suse.cz, jeff.liu@oracle.com, achender@linux.vnet.ibm.com,
	adityakali@google.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58244 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1I2Glj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 02:41:39 -0400
Received: by ywb5 with SMTP id 5so247129ywb.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Sep 2011 23:41:38 -0700 (PDT)
In-Reply-To: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let ext4 initialize delayed extent tree of a inode.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..247fcdd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -882,6 +882,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
+	ext4_de_init_tree(&ei->i_de_tree);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
-- 
1.7.5.1

