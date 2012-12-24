From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 1/9 v1] ext4: fixup metadata reserve block warning when bigalloc and delalloc are enabled
Date: Mon, 24 Dec 2012 15:55:34 +0800
Message-ID: <1356335742-11793-2-git-send-email-wenqing.lz@taobao.com>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38077 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2LXHmU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2012 02:42:20 -0500
Received: by mail-pa0-f47.google.com with SMTP id fa10so3931302pad.20
        for <linux-ext4@vger.kernel.org>; Sun, 23 Dec 2012 23:42:20 -0800 (PST)
In-Reply-To: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When bigalloc and delalloc are enabled, some stress tests (e.g. xfstest #13)
will trigger this warning because all metadata reserved spaces will be released
after dirty pages are written out.  But we still needs to allocate one block,
such as growing the extent tree.  So *DO NOT* release these metadata blocks when
bigalloc and delaloc are enabled.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cb1c1ab..91542be 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -375,10 +375,16 @@ void ext4_da_update_reserve_space(struct inode *inode,
 		 * We can release all of the reserved metadata blocks
 		 * only when we have written all of the delayed
 		 * allocation blocks.
+		 * When bigalloc and delalloc are enabled, we couldn't release
+		 * all of reserved metadata blocks, although all delay blocks
+		 * are written out, because it still has some metadata blocks
+		 * which are allocated.
 		 */
-		percpu_counter_sub(&sbi->s_dirtyclusters_counter,
-				   ei->i_reserved_meta_blocks);
-		ei->i_reserved_meta_blocks = 0;
+		if (sbi->s_cluster_ratio == 1) {
+			percpu_counter_sub(&sbi->s_dirtyclusters_counter,
+					   ei->i_reserved_meta_blocks);
+			ei->i_reserved_meta_blocks = 0;
+		}
 		ei->i_da_metadata_calc_len = 0;
 	}
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-- 
1.7.12.rc2.18.g61b472e

