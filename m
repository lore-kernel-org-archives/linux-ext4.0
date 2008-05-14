From: akpm@linux-foundation.org
Subject: [patch 15/25] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Wed, 14 May 2008 16:05:47 -0700
Message-ID: <200805142305.m4EN5lp2025801@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, tiger.yang@oracle.com, adilger@sun.com,
	agruen@suse.de, linux-ext4@vger.kernel.org, stable@kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbYENXM5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 19:12:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tiger Yang <tiger.yang@oracle.com>

This fix the uninitialized bs when we try to replace a xattr entry in
ibody with the new value which require more than free space.

This situation only happens we format ext3/4 with inode size more than 128 and
we have put xattr entries both in ibody and block.  The consequences about
this bug is we will lost the xattr block which pointed by i_file_acl with all
xattr entires in it.  We will alloc a new xattr block and put that large value
entry in it.  The old xattr block will become orphan block.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/xattr.c |    5 +++++
 fs/ext4/xattr.c |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN fs/ext3/xattr.c~ext3-4-fix-uninitialized-bs-in-ext3-4_xattr_set_handle fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~ext3-4-fix-uninitialized-bs-in-ext3-4_xattr_set_handle
+++ a/fs/ext3/xattr.c
@@ -1000,6 +1000,11 @@ ext3_xattr_set_handle(handle_t *handle, 
 			i.value = NULL;
 			error = ext3_xattr_block_set(handle, inode, &i, &bs);
 		} else if (error == -ENOSPC) {
+			if (EXT3_I(inode)->i_file_acl && !bs.s.base) {
+				error = ext3_xattr_block_find(inode, &i, &bs);
+				if (error)
+					goto cleanup;
+			}
 			error = ext3_xattr_block_set(handle, inode, &i, &bs);
 			if (error)
 				goto cleanup;
diff -puN fs/ext4/xattr.c~ext3-4-fix-uninitialized-bs-in-ext3-4_xattr_set_handle fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~ext3-4-fix-uninitialized-bs-in-ext3-4_xattr_set_handle
+++ a/fs/ext4/xattr.c
@@ -1009,6 +1009,11 @@ ext4_xattr_set_handle(handle_t *handle, 
 			i.value = NULL;
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
 		} else if (error == -ENOSPC) {
+			if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
+				error = ext4_xattr_block_find(inode, &i, &bs);
+				if (error)
+					goto cleanup;
+			}
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
 			if (error)
 				goto cleanup;
_
