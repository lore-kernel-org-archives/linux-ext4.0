From: akpm@linux-foundation.org
Subject: + ext3-4-fix-uninitialized-bs-in-ext3-4_xattr_set_handle.patch added to -mm tree
Date: Mon, 12 May 2008 17:03:00 -0700
Message-ID: <200805130003.m4D0301w015742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: tiger.yang@oracle.com, agruen@suse.de, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
has been added to the -mm tree.  Its filename is
     ext3-4-fix-uninitialized-bs-in-ext3-4_xattr_set_handle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
From: Tiger Yang <tiger.yang@oracle.com>

This fix the uninitialized bs when we try to replace a xattr entry in
ibody with the new value which require more than free space.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Gruenbacher <agruen@suse.de>
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

Patches currently in -mm which might be from tiger.yang@oracle.com are

ext3-4-fix-uninitialized-bs-in-ext3-4_xattr_set_handle.patch

