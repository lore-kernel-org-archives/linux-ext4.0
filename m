From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/7] libext2fs: Don't make a copy of the inode in ext2fs_extent_open2()
Date: Thu, 22 Jul 2010 10:03:14 -0400
Message-ID: <1279807398-13680-4-git-send-email-tytso@mit.edu>
References: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Renzo Davoli <renzo@cs.unibo.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34071 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436Ab0GVODW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 10:03:22 -0400
In-Reply-To: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously, ext2fs_extent_open2() copied the passed-in inode structure
into the extent handle, and the extent functions modified the copy of
the inode structure if necessary due to extent splits, etc.  Change
ext2fs_extent_open2() so that the extent functions use the inode
structure passed into ext2fs_extent_open2().  Otherwise the passed-in
inode structure could become out of date due to changes made by the
extent functions.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/extent.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 490dbe8..5e07092 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -53,6 +53,7 @@ struct ext2_extent_handle {
 	ext2_filsys		fs;
 	ext2_ino_t 		ino;
 	struct ext2_inode	*inode;
+	struct ext2_inode	inodebuf;
 	int			type;
 	int			level;
 	int			max_depth;
@@ -165,8 +166,6 @@ extern void ext2fs_extent_free(ext2_extent_handle_t handle)
 	if (!handle)
 		return;
 
-	if (handle->inode)
-		ext2fs_free_mem(&handle->inode);
 	if (handle->path) {
 		for (i=1; i <= handle->max_depth; i++) {
 			if (handle->path[i].buf)
@@ -203,17 +202,13 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 		return retval;
 	memset(handle, 0, sizeof(struct ext2_extent_handle));
 
-	retval = ext2fs_get_mem(sizeof(struct ext2_inode), &handle->inode);
-	if (retval)
-		goto errout;
