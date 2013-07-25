From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] ext4: remove the entry from es tree when bigalloc is enabled
Date: Fri, 26 Jul 2013 07:42:06 +0800
Message-ID: <1374795726-28859-1-git-send-email-wenqing.lz@taobao.com>
Cc: Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53882 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3GYXmU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jul 2013 19:42:20 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so1590697pad.2
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jul 2013 16:42:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Now in ext4_da_page_release_reservation() we remove the entry from es
tree if to_release != 0.  But there are two issues.  One is that it is
wrong when blocksize != pagesize, another is that we don't need to do
this if ->s_cluster_ratio == 1 because we will remove the entry in
ext4_truncate/ext4_punch_hole.  Here we need to do this just because
when ->s_cluster_ratio > 1 we will determine whether we can release
the reserved space according to ext4_find_delalloc_cluster().

This commit tries to fix these problems.  Now we remove the entry from
es tree only if ->s_cluster_ratio > 1.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
v2:
 * fix a typo in comment.

 fs/ext4/inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ba33c67..2cc97a4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1387,7 +1387,15 @@ static void ext4_da_page_release_reservation(struct page *page,
 		curr_off = next_off;
 	} while ((bh = bh->b_this_page) != head);
 
-	if (to_release) {
+	/*
+	 * Here we need to remove the entry from es tree because when bigalloc
+	 * is enabled we need to determine whether we can release the reserved
+	 * space according to the result of ext4_find_delalloc_cluster().
+	 *
+	 * If bigalloc is disabled, we don't need to do this here because these
+	 * entries in es tree will be removed in ext4_truncate/ext4_punch_hole.
+	 */
+	if (sbi->s_cluster_ratio > 1 && to_release) {
 		lblk = page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
 		ext4_es_remove_extent(inode, lblk, to_release);
 	}
-- 
1.7.9.7

