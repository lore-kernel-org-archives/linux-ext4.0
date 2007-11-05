From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] allow tune2fs to set/clear resize_inode
Date: Mon, 05 Nov 2007 14:45:41 -0600
Message-ID: <472F80F5.3030608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXKEUpr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 15:45:47 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA5KjkhB004956
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 15:45:46 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA5KjkEJ012627
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 15:45:46 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lA5KjgAp010208
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 15:45:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

(this patch has been carried in Red Hat / Fedora rpms for a while, not 
sure why it never got sent upstream... clearing this allows for mounting 
filesystems with a resize_inode on older systems)

-----------------

Allow tune2fs to set & clear resize_inode; requires fsck afterwards.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Addresses-Red-Hat-Bugzilla: #167816

Index: e2fsprogs-git/misc/tune2fs.c
===================================================================
--- e2fsprogs-git.orig/misc/tune2fs.c
+++ e2fsprogs-git/misc/tune2fs.c
@@ -96,6 +96,7 @@ static void usage(void)
 
 static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE,		/* Incompat */
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
@@ -283,6 +284,7 @@ static void update_feature_set(ext2_fils
 {
 	int sparse, old_sparse, filetype, old_filetype;
 	int journal, old_journal, dxdir, old_dxdir;
+	int resize_inode, old_resize_inode;
 	struct ext2_super_block *sb= fs->super;
 	__u32	old_compat, old_incompat, old_ro_compat;
 
@@ -298,6 +300,8 @@ static void update_feature_set(ext2_fils
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	old_dxdir = sb->s_feature_compat &
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
+	old_resize_inode = sb->s_feature_compat &
+		EXT2_FEATURE_COMPAT_RESIZE_INODE;
 	if (e2p_edit_feature(features, &sb->s_feature_compat,
 			     ok_features)) {
 		fprintf(stderr, _("Invalid filesystem option set: %s\n"),
@@ -312,6 +316,8 @@ static void update_feature_set(ext2_fils
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	dxdir = sb->s_feature_compat &
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
+	resize_inode = sb->s_feature_compat &
+		EXT2_FEATURE_COMPAT_RESIZE_INODE;
 	if (old_journal && !journal) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&
 		    !(mount_flags & EXT2_MF_READONLY)) {
@@ -358,7 +364,8 @@ static void update_feature_set(ext2_fils
 	     sb->s_feature_incompat))
 		ext2fs_update_dynamic_rev(fs);
 	if ((sparse != old_sparse) ||
-	    (filetype != old_filetype)) {
+	    (filetype != old_filetype) ||
+	    (resize_inode != old_resize_inode)) {
 		sb->s_state &= ~EXT2_VALID_FS;
 		printf("\n%s\n", _(please_fsck));
 	}
Index: e2fsprogs-git/misc/tune2fs.8.in
===================================================================
--- e2fsprogs-git.orig/misc/tune2fs.8.in
+++ e2fsprogs-git/misc/tune2fs.8.in
@@ -392,12 +392,16 @@ option.
 .TP
 .B sparse_super
 Limit the number of backup superblocks to save space on large filesystems.
+.TP
+.B resize_inode
+Reserve space so the block group descriptor table may grow in the future.
 .RE
 .IP
 After setting or clearing 
-.B sparse_super
-and 
-.B filetype 
+.BR sparse_super ,
+.BR filetype ,
+or
+.B resize_inode
 filesystem features,
 .BR e2fsck (8)
 must be run on the filesystem to return the filesystem to a consistent state.
