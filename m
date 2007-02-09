From: Andreas Dilger <adilger@clusterfs.com>
Subject: [PATCH] e2fsck journal recovery can corrupt all superblock backups
Date: Thu, 8 Feb 2007 23:24:44 -0700
Message-ID: <20070209062444.GA2438@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jim Garlick <garlick@llnl.gov>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:49188 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946148AbXBIGYr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 01:24:47 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,
this was sent with the first patch, and it looks like it is a very
serious problem.

Looking through the e2fsck code it would also seem possible to move the
setting of EXT2_FLAG_MASTER_SB_ONLY before the journal replay.  That
is the second patch.  I'm not sure which one is better.

Jim Garlick wrote:
> When fsck replays the journal, it clears the EXT3_FEATURE_INCOMPAT_RECOVER
> feature, dirties the superblock, and closes the file system.
> Unfortunately, the file system EXT2_FLAG_MASTER_SB_ONLY flag is not set
> at this time, so it copies the primary superblock and group descriptors
> over all the backups.  Then fsck restarts and checks the superblock for
> consistancy.  If the superblock or group descriptors are then found to
> be bad, all your backups are now also bad.

Index: e2fsprogs+chaos/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs+chaos.orig/lib/ext2fs/openfs.c
+++ e2fsprogs+chaos/lib/ext2fs/openfs.c
@@ -101,6 +101,8 @@ errcode_t ext2fs_open2(const char *name,
 	memset(fs, 0, sizeof(struct struct_ext2_filsys));
 	fs->magic = EXT2_ET_MAGIC_EXT2FS_FILSYS;
 	fs->flags = flags;
+	/* don't overwrite sb backups unless flag is explicitly cleared */
+	fs->flags |= EXT2_FLAG_MASTER_SB_ONLY; 
 	fs->umask = 022;
 	retval = ext2fs_get_mem(strlen(name)+1, &fs->device_name);
 	if (retval)

---------------------------------------------------------------------------

Index: e2fsprogs/e2fsck/unix.c
===================================================================
--- e2fsprogs.orig/e2fsck/unix.c	2006-12-27 17:12:23.000000000 -0700
+++ e2fsprogs/e2fsck/unix.c	2007-02-08 22:05:13.000000000 -0700
@@ -1153,6 +1153,15 @@ restart:
 	}
 
 	/*
+	 * We only update the master superblock because (a) paranoia;
+	 * we don't want to corrupt the backup superblocks, and (b) we
+	 * don't need to update the mount count and last checked
+	 * fields in the backup superblock (the kernel doesn't
+	 * update the backup superblocks anyway).
+	 */
+	fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
+
+	/*
 	 * Check to see if we need to do ext3-style recovery.  If so,
 	 * do it, and then restart the fsck.
 	 */
@@ -1227,15 +1236,6 @@ restart:
 	    !(ctx->options & E2F_OPT_READONLY))
 		ext2fs_mark_super_dirty(fs);
 
-	/*
-	 * We only update the master superblock because (a) paranoia;
-	 * we don't want to corrupt the backup superblocks, and (b) we
-	 * don't need to update the mount count and last checked
-	 * fields in the backup superblock (the kernel doesn't
-	 * update the backup superblocks anyway).
-	 */
-	fs->flags |= EXT2_FLAG_MASTER_SB_ONLY;
-
 	ehandler_init(fs->io);
 
 	if (ctx->superblock)

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
