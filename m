From: Daniel Drake <ddrake@brontes3d.com>
Subject: [PATCH e2fsprogs] Restore backup superblocks in preen mode
Date: Tue,  8 May 2007 18:43:24 +0100 (BST)
Message-ID: <20070508174324.40EBE7B409F@zog.reactivated.net>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:52887 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965337AbXEHRn0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2007 13:43:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The restoration of backup superblocks seems to be reversed in the current
e2fsprogs:

When running without preen mode, e2fsck searches and locates a backup
superblock and fixes the primary superblock without any user intervention.

When running in preen mode, e2fsck prints a message describing how the user
can specify the location of a backup superblock, and exits without doing any
repair.

This patch corrects the issue.

Signed-off-by: Daniel Drake <d.drake@mmm.com>

Index: e2fsprogs-1.39/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/unix.c
+++ e2fsprogs-1.39/e2fsck/unix.c
@@ -932,7 +932,7 @@ restart:
 	} else 
 		retval = ext2fs_open2(ctx->filesystem_name, ctx->io_options, 
 				      flags, 0, 0, io_ptr, &fs);
-	if (!ctx->superblock && !(ctx->options & E2F_OPT_PREEN) &&
+	if (!ctx->superblock && (ctx->options & E2F_OPT_PREEN) &&
 	    !(ctx->flags & E2F_FLAG_SB_SPECIFIED) &&
 	    ((retval == EXT2_ET_BAD_MAGIC) ||
 	     ((retval == 0) && ext2fs_check_desc(fs)))) {
