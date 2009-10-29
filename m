From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH][64-bit e2fsprogs] 64-bit block number truncated in e2sck pass2.
Date: Thu, 29 Oct 2009 10:09:53 -0400
Message-ID: <26329.1256825393@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173017pub.verizon.net ([206.46.173.17]:44150 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbZJ2OJs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 10:09:48 -0400
Received: from gamaville.dokosmarshall.org ([173.76.32.106])
 by vms173017.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KSA003AK4O1GJB1@vms173017.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Thu, 29 Oct 2009 09:09:42 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patch resolves the problem that I reported last week - see

    http://thread.gmane.org/gmane.comp.file-systems.ext4/16070


The > 2^32 block number of a directory was being truncated because the
old ext2fs_read_dir_block() routine was called. In addition to the
blk64_t, the new routine takes an additional flags argument (which is
ignored except in the BIG_ENDIAN case).

But this patch is incomplete: there is another instance of
ext2fs_read_dir_block() in pass1.c, in the routine check_is_really_dir()
- unfortunately that routine seems to be applicable only to block-based
inodes, not extent-based ones. The call to ext2fs_read_dir_block() looks
like this:

        retval = ext2fs_read_dir_block(ctx->fs, inode->i_block[0], buf);
 
and there is mucking around with the i_block array beforehand, but no
provision for extents. The routine comes with the following comment:

/*
 * Check to see if the inode might really be a directory, despite i_mode
 *
 * This is a lot of complexity for something for which I'm not really
 * convinced happens frequently in the wild.  If for any reason this
 * causes any problems, take this code out.
 * [tytso:20070331.0827EDT]
 */

So before rewriting it to deal with extents, I thought I'd ask the question:
is the routine worth keeping?

Thanks,
Nick

---------------------------------------------------------------------------

>From 99cd1625c4cf48eab97b947527fbf51e3bf7b9c5 Mon Sep 17 00:00:00 2001
From: Nick Dokos <nicholas.dokos@hp.com>
Date: Wed, 28 Oct 2009 23:28:51 -0400
Subject: [PATCH] 64-bit fix: ext2fs_read_dir_block() changed to ext2fs_read_dir_block3().

The former takes a blk_t, the latter a blk64_t argument. We also need
to pass the fs flags as an additional argument, although it's only used
in big endian architectures.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 e2fsck/pass2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index b757131..7b75f83 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -780,7 +780,7 @@ static int check_dir_block(ext2_filsys fs,
 #endif
 
 	old_op = ehandler_operation(_("reading directory block"));
-	cd->pctx.errcode = ext2fs_read_dir_block(fs, block_nr, buf);
+	cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, fs->flags);
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
-- 
1.6.0.6

