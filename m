From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] mke2fs: prompt for user verification for "-S"
Date: Fri, 22 May 2015 16:43:08 -0600
Message-ID: <1432334588-18387-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-02.shaw.ca ([64.59.136.138]:39733 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422688AbbEVWnK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 May 2015 18:43:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Prompt for user verification before rewriting the filesystem
superblocks using the "-S" (super-only) option.  This should
not normally be used at all, so adding the extra verification
will probably save a few user filesystems in the future.  Since
this is something that should only be done in rare cases under
user supervision, wait for user input rather than proceeding
automatically after a timeout.

Update the mke2fs man page to more fully explain the many
dangers of this option.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/mke2fs.8.in |   24 ++++++++++++++++--------
 misc/mke2fs.c    |    7 ++++++-
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 1002eae..2a50ad2 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -619,18 +619,26 @@ kernels only support revision 0 filesystems.  The default is to
 create revision 1 filesystems.
 .TP
 .B \-S
-Write superblock and group descriptors only.  This is useful if all of
+Write superblock and group descriptors only.  This is an extreme
+measure to be taken only in the very unlikely case that all of
 the superblock and backup superblocks are corrupted, and a last-ditch
-recovery method is desired.  It causes
+recovery method is desired by experienced users.  It causes
 .B mke2fs
-to reinitialize the
-superblock and group descriptors, while not touching the inode table
-and the block and inode bitmaps.  The
+to reinitialize the superblock and group descriptors, while not
+touching the inode table and the block and inode bitmaps.  The
 .B e2fsck
 program should be run immediately after this option is used, and there
-is no guarantee that any data will be salvageable.  It is critical to
-specify the correct filesystem blocksize when using this option,
-or there is no chance of recovery.
+is no guarantee that any data will be salvageable.  Due to the wide
+variety of possible options to
+.BR mke2fs
+that affect the on-disk layout, is critical to specify exactly the same
+the same format options, such as blocksize, fs-type, feature flags, and
+other tunables when using this option, or the filesystem will be further
+corrupted.  In some cases, such as filesystems that have been resized,
+or have had features enabled after format time, it is impossible to
+overwrite all of the superblocks corretly, and at least some filesystem
+corruption will occur.  It is best to run this on a full copy of the
+filesystem so other options can be tried if this doesn't work.
 .\" .TP
 .\" .BI \-t " test"
 .\" Check the device for bad blocks before creating the file system
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a14e62e..e49ad04 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2771,9 +2771,14 @@ int main (int argc, char *argv[])
 	}
 
 	if (super_only) {
+		check_plausibility(device_name, CHECK_FS_EXIST, NULL);
+		printf(_("%s may be further corrupted by superblock rewrite\n"),
+		       device_name);
+		if (!force)
+			proceed_question(proceed_delay);
 		fs->super->s_state |= EXT2_ERROR_FS;
 		fs->flags &= ~(EXT2_FLAG_IB_DIRTY|EXT2_FLAG_BB_DIRTY);
-		/* 
+		/*
 		 * The command "mke2fs -S" is used to recover
 		 * corrupted file systems, so do not mark any of the
 		 * inodes as unused; we want e2fsck to consider all
-- 
1.7.3.4

