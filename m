From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] quota: swapping s_prj_quota_inum superblock field
Date: Wed, 13 Dec 2017 15:20:18 +0300
Message-ID: <20171213122018.27932-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:45135 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbdLMMUY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2017 07:20:24 -0500
Received: by mail-lf0-f66.google.com with SMTP id f13so2379202lff.12
        for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2017 04:20:24 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_swap_super() swaps s_usr_quota_inum and
s_grp_quota_inum fields but not s_prj_quota_inum.

This patch adds s_prj_quota_inum swapping.

Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>`
---
 lib/ext2fs/swapfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index b9d8f557..c1da8509 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -79,6 +79,7 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_snapshot_r_blocks_count =
 		ext2fs_swab64(sb->s_snapshot_r_blocks_count);
 	sb->s_snapshot_list = ext2fs_swab32(sb->s_snapshot_list);
+	sb->s_prj_quota_inum = ext2fs_swab32(sb->s_prj_quota_inum);
 	sb->s_usr_quota_inum = ext2fs_swab32(sb->s_usr_quota_inum);
 	sb->s_grp_quota_inum = ext2fs_swab32(sb->s_grp_quota_inum);
 	sb->s_overhead_blocks = ext2fs_swab32(sb->s_overhead_blocks);
-- 
2.14.3 (Apple Git-98)
