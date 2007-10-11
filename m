From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 05/13][e2fsprogs] Make tune2fs uninit block group aware.
Date: Thu, 11 Oct 2007 14:16:29 -0500
Message-ID: <20071011191629.4599.28833.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32857 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbXJKTQh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 15:16:37 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJGaFT002858
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:36 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJGaIK116352
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:36 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJGQlM019716
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:26 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJGQDm019153
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:26 -0400
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJGFAs040726
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:16:15 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Make tune2fs uninit block group aware.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 misc/tune2fs.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 833b994..e2ebc08 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -98,7 +98,8 @@ static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE,		/* Incompat */
-	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
+	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |	/* R/O compat */
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
 
 /*
@@ -213,6 +214,8 @@ static int release_blocks_proc(ext2_filsys fs, blk_t *blocknr,
 	ext2fs_unmark_block_bitmap(fs->block_map,block);
 	group = ext2fs_group_of_blk(fs, block);
 	fs->group_desc[group].bg_free_blocks_count++;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, group,&fs->group_desc[group]);
 	fs->super->s_free_blocks_count++;
 	return 0;
 }
@@ -282,7 +285,7 @@ static void update_mntopts(ext2_filsys fs, char *mntopts)
 static void update_feature_set(ext2_filsys fs, char *features)
 {
 	int sparse, old_sparse, filetype, old_filetype;
-	int journal, old_journal, dxdir, old_dxdir;
+	int journal, old_journal, dxdir, old_dxdir, uninit, old_uninit;
 	struct ext2_super_block *sb= fs->super;
 	__u32	old_compat, old_incompat, old_ro_compat;
 
@@ -298,6 +301,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	old_dxdir = sb->s_feature_compat &
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
+	old_uninit = sb->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 	if (e2p_edit_feature(features, &sb->s_feature_compat,
 			     ok_features)) {
 		fprintf(stderr, _("Invalid filesystem option set: %s\n"),
@@ -312,6 +317,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	dxdir = sb->s_feature_compat &
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
+	old_uninit = sb->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 	if (old_journal && !journal) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&
 		    !(mount_flags & EXT2_MF_READONLY)) {
@@ -358,6 +365,7 @@ static void update_feature_set(ext2_filsys fs, char *features)
 	     sb->s_feature_incompat))
 		ext2fs_update_dynamic_rev(fs);
 	if ((sparse != old_sparse) ||
+	    (uninit != old_uninit) ||
 	    (filetype != old_filetype)) {
 		sb->s_state &= ~EXT2_VALID_FS;
 		printf("\n%s\n", _(please_fsck));
