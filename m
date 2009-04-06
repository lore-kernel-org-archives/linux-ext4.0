From: akpm@linux-foundation.org
Subject: [merged] ext3-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:48 -0700
Message-ID: <200904061933.n36JXmJN011275@imap1.linux-foundation.org>
To: bdonlan@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405AbZDFTfs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 15:35:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: return -EIO not -ESTALE on directory traversal through deleted inode
has been removed from the -mm tree.  Its filename was
     ext3-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: return -EIO not -ESTALE on directory traversal through deleted inode
From: Bryan Donlan <bdonlan@gmail.com>

ext3_iget() returns -ESTALE if invoked on a deleted inode, in order to
report errors to NFS properly.  However, in ext[234]_lookup(), this
-ESTALE can be propagated to userspace if the filesystem is corrupted such
that a directory entry references a deleted inode.  This leads to a
misleading error message - "Stale NFS file handle" - and confusion on the
part of the admin.

The bug can be easily reproduced by creating a new filesystem, making a
link to an unused inode using debugfs, then mounting and attempting to ls
-l said link.

This patch thus changes ext3_lookup to return -EIO if it receives -ESTALE
from ext3_iget(), as ext3 does for other filesystem metadata corruption;
and also invokes the appropriate ext*_error functions when this case is
detected.

Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/ext3/namei.c~ext3-return-eio-not-estale-on-directory-traversal-through-deleted-inode fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-return-eio-not-estale-on-directory-traversal-through-deleted-inode
+++ a/fs/ext3/namei.c
@@ -1047,8 +1047,16 @@ static struct dentry *ext3_lookup(struct
 			return ERR_PTR(-EIO);
 		}
 		inode = ext3_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+		if (unlikely(IS_ERR(inode))) {
+			if (PTR_ERR(inode) == -ESTALE) {
+				ext3_error(dir->i_sb, __func__,
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

origin.patch

