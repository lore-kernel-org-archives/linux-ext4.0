From: akpm@linux-foundation.org
Subject: [patch 10/28] ext2: return -EIO not -ESTALE on directory traversal through deleted inode
Date: Tue, 30 Jun 2009 11:41:24 -0700
Message-ID: <200906301841.n5UIfPYi001504@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, bdonlan@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbZF3Sle (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jun 2009 14:41:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Bryan Donlan <bdonlan@gmail.com>

ext2_iget() returns -ESTALE if invoked on a deleted inode, in order to
report errors to NFS properly.  However, in ext[234]_lookup(), this
-ESTALE can be propagated to userspace if the filesystem is corrupted such
that a directory entry references a deleted inode.  This leads to a
misleading error message - "Stale NFS file handle" - and confusion on the
part of the admin.

The bug can be easily reproduced by creating a new filesystem, making a
link to an unused inode using debugfs, then mounting and attempting to ls
-l said link.

This patch thus changes ext2_lookup to return -EIO if it receives -ESTALE
from ext2_iget(), as ext2 does for other filesystem metadata corruption;
and also invokes the appropriate ext*_error functions when this case is
detected.

Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/ext2/namei.c~ext2-return-eio-not-estale-on-directory-traversal-through-deleted-inode fs/ext2/namei.c
--- a/fs/ext2/namei.c~ext2-return-eio-not-estale-on-directory-traversal-through-deleted-inode
+++ a/fs/ext2/namei.c
@@ -66,8 +66,16 @@ static struct dentry *ext2_lookup(struct
 	inode = NULL;
 	if (ino) {
 		inode = ext2_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+		if (unlikely(IS_ERR(inode))) {
+			if (PTR_ERR(inode) == -ESTALE) {
+				ext2_error(dir->i_sb, __func__,
+						"deleted inode referenced: %lu",
+						ino);
+				return ERR_PTR(-EIO);
+			} else {
+				return ERR_CAST(inode);
+			}
+		}
 	}
 	return d_splice_alias(inode, dentry);
 }
_
