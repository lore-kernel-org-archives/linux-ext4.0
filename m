From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] fix check_mntent_file() to pass mode for open(O_CREAT)
Date: Thu, 8 Nov 2007 18:20:15 -0700
Message-ID: <20071109012015.GA14612@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:53888 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXKIBUS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2007 20:20:18 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On my FC8 install, ismounted.c fails to build because open(O_CREAT) is
used without passing a mode.  The following trivial patch fixes it.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Index: e2fsprogs-1.40.2/lib/ext2fs/ismounted.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/ismounted.c
+++ e2fsprogs-1.40.2/lib/ext2fs/ismounted.c
@@ -147,7 +147,7 @@ static errcode_t check_mntent_file(const
 is_root:
 #define TEST_FILE "/.ismount-test-file"		
 		*mount_flags |= EXT2_MF_ISROOT;
-		fd = open(TEST_FILE, O_RDWR|O_CREAT);
+		fd = open(TEST_FILE, O_RDWR|O_CREAT, 0600);
 		if (fd < 0) {
 			if (errno == EROFS)
 				*mount_flags |= EXT2_MF_READONLY;

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
