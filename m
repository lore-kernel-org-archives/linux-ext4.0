From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Mon, 13 Aug 2007 23:33:03 -0500
Message-ID: <20070814043303.32206.10239.stgit@gara>
References: <20070814043245.32206.34785.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34647 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177AbXHNEdS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2007 00:33:18 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7E4XH7s015381
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:17 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7E4XHSb530112
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:17 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7E4XGsf019645
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:17 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7E4XGgB019622
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:33:16 -0400
Received: from [127.0.1.1] (sig-9-65-58-9.mts.ibm.com [9.65.58.9])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7E4XGQs040304
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 23:33:16 -0500
In-Reply-To: <20070814043245.32206.34785.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Relax group descriptor checking.

In order for tools such as dump2efs, e2fsck and debugfs to open a ext4
filesystem with FLEX_BG feature enable, some descriptor checking needs
to be relaxed.  This patch changes the group desciptor checking so
that bitmaps and inode tables can be located anywhere in the
partitions block range.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 e2fsck/super.c          |   14 ++++++++++++--
 lib/ext2fs/check_desc.c |   15 +++++++++++++--
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 00a131c..ed28732 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -463,6 +463,8 @@ void check_super_block(e2fsck_t ctx)
 	int	inodes_per_block;
 	int	ipg_max;
 	int	inode_size;
+	dgrp_t	start_group;
+	int 	meta_bg_size;
 	dgrp_t	i;
 	blk_t	should_be;
 	struct problem_context	pctx;
@@ -578,8 +580,16 @@ void check_super_block(e2fsck_t ctx)
 	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
 		pctx.group = i;
 
-		first_block = ext2fs_group_first_block(fs, i);
-		last_block = ext2fs_group_last_block(fs, i);
+		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
+					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+			meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+			start_group = (i / meta_bg_size) * meta_bg_size;
+			first_block = ext2fs_group_first_block(fs, start_group);
+			last_block = ext2fs_group_first_block(fs, start_group + meta_bg_size);
+		} else {
+			first_block = ext2fs_group_first_block(fs, i);
+			last_block = ext2fs_group_last_block(fs, i);
+		}
 
 		if ((gd->bg_block_bitmap < first_block) ||
 		    (gd->bg_block_bitmap > last_block)) {
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 146f9e5..dbbcfb3 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -34,12 +34,23 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 	dgrp_t i;
 	blk_t first_block = fs->super->s_first_data_block;
 	blk_t last_block;
+	dgrp_t start_group;
+	int meta_bg_size;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		first_block = ext2fs_group_first_block(fs, i);
-		last_block = ext2fs_group_last_block(fs, i);
+		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, 
+					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+			meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
+			start_group = (i / meta_bg_size) * meta_bg_size;
+			first_block = ext2fs_group_first_block(fs, start_group);
+			last_block = ext2fs_group_first_block(fs, start_group + meta_bg_size);
+		}
+		else {
+			first_block = ext2fs_group_first_block(fs, i);
+			last_block = ext2fs_group_last_block(fs, i);
+		}
 
 		/*
 		 * Check to make sure block bitmap for group is
