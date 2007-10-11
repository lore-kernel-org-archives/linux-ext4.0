From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 06/13][e2fsprogs] Make dumpe2fs uninit block group aware.
Date: Thu, 11 Oct 2007 14:16:35 -0500
Message-ID: <20071011191635.4599.76640.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49118 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbXJKTQn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 15:16:43 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJIDKn008067
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:18:13 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJGgsl119576
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:42 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJGWMx020108
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:32 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJGWMu019449
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:32 -0400
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJGLrT040728
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:16:21 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Make dumpe2fs uninit block group aware.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
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
