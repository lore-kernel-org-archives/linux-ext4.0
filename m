From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 3/6] ext4: initialize delayed extent tree
Date: Mon, 31 Oct 2011 08:55:44 +0800
Message-ID: <1320022547-2284-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58444 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1JaDAF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 23:00:05 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so6677937iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 20:00:04 -0700 (PDT)
In-Reply-To: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let ext4 initialize delayed extent tree of a inode.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9953d80..9515e5f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -899,6 +899,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
+	ext4_de_init_tree(&ei->i_de_tree);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
-- 
1.7.5.1

