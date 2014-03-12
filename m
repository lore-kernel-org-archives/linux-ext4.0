From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] create_inode: fix gcc -Wall complaints
Date: Tue, 11 Mar 2014 23:41:10 -0400
Message-ID: <1394595670-11193-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40220 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaCLDlP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 23:41:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We had several functions that were not returning zero on success.  Fix
this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/create_inode.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 42ac6b2..964c66a 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -86,10 +86,9 @@ static errcode_t set_inode_extra(ext2_filsys fs, ext2_ino_t cwd,
 	fill_inode(&inode, st);
 
 	retval = ext2fs_write_inode(fs, ino, &inode);
-	if (retval) {
+	if (retval)
 		com_err(__func__, retval, "while writing inode %u", ino);
-		return retval;
-	}
+	return retval;
 }
 
 /* Make a special file which is block, character and fifo */
@@ -115,6 +114,9 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 		mode = LINUX_S_IFIFO;
 		filetype = EXT2_FT_FIFO;
 		break;
+	default:
+		abort();
+		/* NOTREACHED */
 	}
 
 	if (!(fs->flags & EXT2_FLAG_RW)) {
@@ -204,11 +206,9 @@ try_again:
 		}
 		goto try_again;
 	}
-	if (retval) {
+	if (retval)
 		com_err("ext2fs_symlink", retval, 0);
-		return retval;
-	}
