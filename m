From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Wed, 22 Aug 2012 14:05:40 +0800
Message-ID: <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab2HVFzw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Aug 2012 01:55:52 -0400
In-Reply-To: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Let ext4 initialize extent status tree of an inode.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3e0851e..353b1fd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -944,6 +944,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
+	ext4_es_init_tree(&ei->i_es_tree);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
-- 
1.7.4.1

