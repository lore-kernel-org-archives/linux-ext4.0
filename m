From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 10/17] signed int -> blk64_t to fix bugs at 2^31 - 2^32 blocks
Date: Tue, 11 Nov 2008 19:43:03 -0800
Message-ID: <1226461390-5502-11-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42470 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbYKLDn7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:59 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hxMa007453
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:59 -0500
In-Reply-To: <1226461390-5502-10-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 lib/ext2fs/alloc_tables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 7235f7d..71ad445 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -147,7 +147,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	}
 
 	if (flexbg_size) {
-		int prev_block = 0;
+		blk64_t prev_block = 0;
 		if (group && ext2fs_inode_bitmap_loc(fs, group - 1))
 			prev_block = ext2fs_inode_bitmap_loc(fs, group - 1);
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
@@ -178,7 +178,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	 * Allocate the inode table
 	 */
 	if (flexbg_size) {
-		int prev_block = 0;
+		blk64_t prev_block = 0;
 		if (group && ext2fs_inode_table_loc(fs, group - 1))
 			prev_block = ext2fs_inode_table_loc(fs, group - 1);
 		group_blk = flexbg_offset(fs, group, prev_block, bmap,
-- 
1.5.6.5

