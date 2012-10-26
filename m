From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/8 v3] ext4: initialize extent status tree
Date: Fri, 26 Oct 2012 21:23:40 +0800
Message-ID: <1351257825-3701-4-git-send-email-wenqing.lz@taobao.com>
References: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, hughd@google.com, xiaoqiangnk@gmail.com,
	achender@linux.vnet.ibm.com, lczerner@redhat.com,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, jeff.liu@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52319 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab2JZNMz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 09:12:55 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1922583pad.19
        for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2012 06:12:55 -0700 (PDT)
In-Reply-To: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Let ext4 initialize extent status tree of an inode.

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
v3 <- v2:
 - initialize i_es_lock

 fs/ext4/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..e0c824b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -943,6 +943,8 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
+	ext4_es_init_tree(&ei->i_es_tree);
+	rwlock_init(&ei->i_es_lock);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
-- 
1.7.12.rc2.18.g61b472e

