From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 11/17] Fix overflow in calculation of total file system blocks
Date: Tue, 11 Nov 2008 19:43:04 -0800
Message-ID: <1226461390-5502-12-git-send-email-vaurora@redhat.com>
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
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42471 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbYKLDoA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:44:00 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3i0LB007457
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:44:00 -0500
In-Reply-To: <1226461390-5502-11-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Blocks per group and group desc count are both 32-bit; multiplied they
produce a 32-bit quantity which overflowed.

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 lib/ext2fs/bitmaps.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/bitmaps.c b/lib/ext2fs/bitmaps.c
index f438a8b..91dc7a1 100644
--- a/lib/ext2fs/bitmaps.c
+++ b/lib/ext2fs/bitmaps.c
@@ -92,8 +92,8 @@ errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 
 	start = fs->super->s_first_data_block;
 	end = ext2fs_blocks_count(fs->super)-1;
-	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)
-		    * fs->group_desc_count)-1 + start;
+	real_end = ((__u64) EXT2_BLOCKS_PER_GROUP(fs->super)
+		    * (__u64) fs->group_desc_count)-1 + start;
 
 	if (fs->flags & EXT2_FLAG_NEW_BITMAPS)
 		return (ext2fs_alloc_generic_bmap(fs,
-- 
1.5.6.5

