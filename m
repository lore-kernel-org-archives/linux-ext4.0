From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 06/14] Make tune2fs uninit block group aware.
Date: Sun, 21 Oct 2007 21:03:41 -0500
Message-ID: <20071022020341.23849.98782.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:46982 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbXJVCHH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:07:07 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l9M0w4QM016594
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:58:04 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M276O8083578
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:06 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M276ja008470
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:06 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M276aE008465
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:06 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Make tune2fs uninit block group aware.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
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
