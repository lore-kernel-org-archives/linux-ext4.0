From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/2 v2] ext4: check free inode count before allocaing an inode
Date: Thu,  6 Sep 2012 21:16:55 +0800
Message-ID: <1346937415-2866-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1346937415-2866-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2IFNwb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Sep 2012 09:52:31 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so2536070pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 06 Sep 2012 06:52:31 -0700 (PDT)
In-Reply-To: <1346937415-2866-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Recnetly, I ecountered some corrupted filesystems in which some
groups' free inode counts were 65535, it seemed that free inode
count was overflow.  This patch teaches ext4 to check free inode
count before allocaing an inode.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ialloc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 26154b8..fa36372 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -697,6 +697,15 @@ got_group:
 		if (!gdp)
 			goto fail;
 
+		/*
+		 * Check free inodes count before loading bitmap.
+		 */
+		if (ext4_free_inodes_count(sb, gdp) == 0) {
+			if (++group == ngroups)
+				group = 0;
+			continue;
+		}
+
 		brelse(inode_bitmap_bh);
 		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
 		if (!inode_bitmap_bh)
-- 
1.7.5.1

