From: akpm@linux-foundation.org
Subject: + ext2-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch added to -mm tree
Date: Tue, 17 Feb 2009 16:09:12 -0800
Message-ID: <200902180009.n1I09C7k021533@imap1.linux-foundation.org>
Cc: bdonlan@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486AbZBRAJs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 19:09:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext2: return -EIO not -ESTALE on directory traversal through deleted inode
has been added to the -mm tree.  Its filename is
     ext2-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: return -EIO not -ESTALE on directory traversal through deleted inode
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
+				ext2_error(dir->i_sb, "ext2_lookup",
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

Patches currently in -mm which might be from bdonlan@gmail.com are

ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch
ext2-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch
ext3-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch

