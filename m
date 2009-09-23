From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] always set EXCLUSIVE flag for modifying e2fsck
Date: Wed, 23 Sep 2009 03:56:41 -0600
Message-ID: <20090923095640.GX10562@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62265 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZIWJ4q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2009 05:56:46 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8N9ummG010205
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 02:56:48 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQF00B004T33600@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 23 Sep 2009 02:56:48 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The checks done by e2fsck for mounted vs. read-only runs is confusing.

On the one hand, if e2fsck is NOT run with the "-n" flag (i.e. it might
modify the filesystem, there is no guarantee that it will open the
filesystem with the EXCLUSIVE flag (i.e. O_EXCL) to prevent the block
device from being used (in most cases = mounted).

On the other hand, if the filesystem IS mounted it also does NOT set
the EXCLUSIVE flag to prevent it from clobbering an in-use filesystem.
That seems like a bad choice also.

On the gripping hand, if e2fsck IS run with "-n" (i.e. read-only),
and the /etc/fstab or /proc/mounts does not report the same block
device to match the mountpoint (which happens for Lustre, and can
also happen if there is an overlay mount) then the e2fsck thinks
the filesystem is unmounted, but fails because the EXCLUSIVE flag
is set even though it is running read-only.

Change the logic here so that EXCLUSIVE is ALWAYS set when e2fsck
might modify the filesystem, regardless of whether the filesystem
is mounted or not.

Index: e2fsprogs-1.41.6/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.41.6.orig/e2fsck/unix.c
+++ e2fsprogs-1.41.6/e2fsck/unix.c
@@ -1230,9 +1230,7 @@ restart:
 		io_ptr = unix_io_manager;
 	flags = EXT2_FLAG_NOFREE_ON_ERROR;
        if ((ctx->options & E2F_OPT_READONLY) == 0)
-		flags |= EXT2_FLAG_RW;
-	if ((ctx->mount_flags & EXT2_MF_MOUNTED) == 0)
-		flags |= EXT2_FLAG_EXCLUSIVE;
+		flags |= EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE;
 
 	retval = try_open_fs(ctx, flags, io_ptr, &fs);
 

If we want to assume that check_mount() will abort if the filesystem
is mounted, unless the user wants to shoot themselves in the foot, then 
the above patch could instead be modified to clear EXT2_FLAG_EXCLUSIVE
if the MF_MOUNTED flag IS set, per below.

Index: e2fsprogs-1.41.6/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.41.6.orig/e2fsck/unix.c
+++ e2fsprogs-1.41.6/e2fsck/unix.c
@@ -1230,9 +1230,10 @@ restart:
 		io_ptr = unix_io_manager;
 	flags = EXT2_FLAG_NOFREE_ON_ERROR;
        if ((ctx->options & E2F_OPT_READONLY) == 0)
-		flags |= EXT2_FLAG_RW;
-	if ((ctx->mount_flags & EXT2_MF_MOUNTED) != 0)
-		flags |= EXT2_FLAG_EXCLUSIVE;
+		flags |= EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE;
+	/* we will have aborted in check_mount() unless user asks for this */
+	if ((ctx->mount_flags & EXT2_MF_MOUNTED) != 0)
+		flags &= ~EXT2_FLAG_EXCLUSIVE;
 
 	retval = try_open_fs(ctx, flags, io_ptr, &fs);
 

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

