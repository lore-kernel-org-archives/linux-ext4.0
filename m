From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] initialize error handling before journal replay
Date: Fri, 15 May 2009 12:51:58 -0600
Message-ID: <20090515185158.GQ3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64225 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZEOSwb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 May 2009 14:52:31 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4FIqFc4010094
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 11:52:28 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KJP00M008BJJ500@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 15 May 2009 11:52:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One of our customers hit a temporary IO error during an e2fsck run during
the read from the journal.  It seems that the read error resulted in
e2fsck automatically discarding the journals and recreating them on several
filesystems on this node without any prompting from the user.

end_request: I/O error, dev sdg, sector 484832
Buffer I/O error on device sdg, logical block 60604
fsck-sdg[8276]: ls2-OST024c: Superblock has an invalid ext3 journal (inode 8).
fsck-sdg[8276]: CLEARED.
fsck-sdg[8276]: *** ext3 journal has been deleted - filesystem is now ext2
only ***
fsck-sdg[8276]: ls2-OST024c was not cleanly unmounted, check forced.
fsck-sdg[8276]: ls2-OST024c: Journal inode is not in use, but contains data.
CLEARED.
fsck-sdg[8276]: ls2-OST024c: Recreate journal to make the filesystem ext3
again?
fsck-sdg[8276]: FIXED.
fsck-sdg[8276]: Creating journal (32768 blocks):  Done.
fsck-sdg[8276]:
fsck-sdg[8276]: *** journal has been re-created - filesystem is now ext3 again
***
fsck-sdg[8276]: ls2-OST024c: 39818/20183248 files (8.2% non-contiguous), 222122257/779902976 blocks
fsck-sdg[8276]: exit code 1 (file system errors corrected)

-----------------------------------------------------------------------

The following patch moves the e2fsck error handler initialization earlier
in the e2fsck startup code before the journal is processed, so that the
user will be prompted for an action.  This is the first IO that is not
part of ext2fs_open() where fs->io is first initialized.

It doesn't seem possible to initialize the error handlers for the initial
filesystem open without changing the prototype for ext2fs_open2().  If we
are getting a new ext2fs_open3() prototype for 64-bit it might make sense
to add at least "read_error" as a parameter ("write_error" is not strictly
necessary for the open and could be set afterward).

Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Jim Garlick <garlick@llnl.gov>

Index: e2fsprogs+chaos4/e2fsck/unix.c
===================================================================
--- e2fsprogs+chaos4.orig/e2fsck/unix.c
+++ e2fsprogs+chaos4/e2fsck/unix.c
@@ -1395,6 +1395,8 @@ restart:
 		if (isspace(*cp) || *cp == ':')
 			*cp = '_';
 
+	ehandler_init(fs->io);
+
 	/*
 	 * Make sure the ext3 superblock fields are consistent.
 	 */
@@ -1506,8 +1508,6 @@ print_unsupp_features:
 	if (ctx->blocks_per_page == 0)
 		ctx->blocks_per_page = 1;
 
-	ehandler_init(fs->io);
