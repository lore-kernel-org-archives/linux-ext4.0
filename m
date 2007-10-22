From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 07/14] Make dumpe2fs uninit block group aware.
Date: Sun, 21 Oct 2007 21:03:46 -0500
Message-ID: <20071022020346.23849.36994.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:44592 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbXJVCHM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:07:12 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9M27Cii022162
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 22:07:12 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M27CUe085434
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:12 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M27BvC017384
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:12 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M27BBt017375
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:11 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Make dumpe2fs uninit block group aware.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
--

 misc/dumpe2fs.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index d4d95bb..c08528a 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -112,7 +112,8 @@ static void print_bg_opts(ext2_filsys fs, dgrp_t i)
 {
 	int first = 1, bg_flags;
 
-	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_LAZY_BG)
+	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_LAZY_BG ||
+	    fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
 		bg_flags = fs->group_desc[i].bg_flags;
 	else
 		bg_flags = 0;
@@ -210,11 +211,15 @@ static void list_desc (ext2_filsys fs)
 		diff = fs->group_desc[i].bg_inode_table - first_block;
 		if (diff > 0)
 			printf(" (+%ld)", diff);
-		printf (_("\n  %d free blocks, %d free inodes, "
-			  "%d directories\n"),
+		printf (_("\n  %u free blocks, %u free inodes, "
+			  "%u directories%s"),
 			fs->group_desc[i].bg_free_blocks_count,
 			fs->group_desc[i].bg_free_inodes_count,
-			fs->group_desc[i].bg_used_dirs_count);
+			fs->group_desc[i].bg_used_dirs_count,
+			fs->group_desc[i].bg_itable_unused ? "" : "\n");
+		if (fs->group_desc[i].bg_itable_unused)
+			printf (_(", %u unused inodes\n"),
+				fs->group_desc[i].bg_itable_unused);
 		if (block_bitmap) {
 			fputs(_("  Free blocks: "), stdout);
 			ext2fs_get_block_bitmap_range(fs->block_map, 
