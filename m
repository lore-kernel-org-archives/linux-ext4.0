From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: don't mark the superblock as dirty if the fs was opened r/o
Date: Mon, 20 Feb 2012 20:36:22 -0500
Message-ID: <1329788182-25431-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35365 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab2BUBga (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 20:36:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the file system is read/only opened with a backup superblock, and
the file system has uninit_bg enabled, the super block must not be
marked as dirty; otherwise, ext2fs_close() will call ext2fs_flush(),
which will fail, since the file descriptor for the block device was
opened read/only, and then the file descriptor won't actually be
closed.

This is normally not a problem since most of the time the program will
exit shortly after calling ext2fs_close(), and many programs don't
bother checking the error return from ext2fs_close(), especially if
the file system was opened read/only.

A big exception to this is e2fsck, since it opens and close the file
systems during its startup, and to make matters worse, registers an
error handler which will noisly complain about the failed writes
caused by ext2fs_flush().

Fix this by not marking the superblock as dirty if the file system was
opened read/only.  The changes to the block group descriptors to clear
the uninit bits will still happen, so that e2fsck -n will properly
scan the whole file system.  However, those changes will get dropped
when the file system handle is closed.

Addresses-SourceForge-Bug: #3444351

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/openfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index b1b68ad..32e068c 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -382,7 +382,8 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 			 * anyway to avoid printing a lot of spurious errors. */
 			ext2fs_group_desc_csum_set(fs, group);
 		}
-		ext2fs_mark_super_dirty(fs);
+		if (fs->flags & EXT2_FLAG_RW)
+			ext2fs_mark_super_dirty(fs);
 	}
 
 	fs->flags &= ~EXT2_FLAG_NOFREE_ON_ERROR;
-- 
1.7.9.107.g97f9a

