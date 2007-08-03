From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Thu, 02 Aug 2007 23:00:59 -0500
Message-ID: <20070803040059.29456.55756.stgit@gara>
References: <20070803040041.29456.31454.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38595 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXHCEDY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2007 00:03:24 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7343NJX030480
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:23 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7343NQc068396
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:23 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7343ND6000699
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:23 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7343Mo1000692
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 00:03:22 -0400
Received: from [127.0.1.1] (sig-9-65-28-26.mts.ibm.com [9.65.28.26])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7343LnQ050784
	for <linux-ext4@vger.kernel.org>; Thu, 2 Aug 2007 23:03:22 -0500
In-Reply-To: <20070803040041.29456.31454.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Relax group descriptor checking.

In order for tools such as dump2efs, e2fsck and debugfs to open a ext4
filesystem with FLEX_BG feature enable, some descriptor checking needs
to be relaxed.  This patch changes the group desciptor checking so
that bitmaps and inode tables can be located anywhere in the
partitions block range.

Eventually, a more thorough check would restrict bitmaps and inode
tables to be located at the beginning of a flex block group range.
Since the super block does not currently know about the number of
groups per flex group, this will do for now.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 e2fsck/super.c          |   10 ++++++++--
 lib/ext2fs/check_desc.c |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 00a131c..8e58e5c 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -578,8 +578,14 @@ void check_super_block(e2fsck_t ctx)
 	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
 		pctx.group = i;
 
-		first_block = ext2fs_group_first_block(fs, i);
-		last_block = ext2fs_group_last_block(fs, i);
+		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
+			EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+			first_block = fs->super->s_first_data_block;
+			last_block = fs->super->s_blocks_count;
+		} else {
+			first_block = ext2fs_group_first_block(fs, i);
+			last_block = ext2fs_group_last_block(fs, i);
+		}
 
 		if ((gd->bg_block_bitmap < first_block) ||
 		    (gd->bg_block_bitmap > last_block)) {
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 146f9e5..bb65c06 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -38,8 +38,14 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		first_block = ext2fs_group_first_block(fs, i);
-		last_block = ext2fs_group_last_block(fs, i);
+		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+			first_block = fs->super->s_first_data_block;
+			last_block = fs->super->s_blocks_count;
+		}
+		else {
+			first_block = ext2fs_group_first_block(fs, i);
+			last_block = ext2fs_group_last_block(fs, i);
+		}
 
 		/*
 		 * Check to make sure block bitmap for group is
