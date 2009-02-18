From: akpm@linux-foundation.org
Subject: + ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch added to -mm tree
Date: Tue, 17 Feb 2009 16:08:11 -0800
Message-ID: <200902180008.n1I08BZF020006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: bdonlan@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: return -EIO not -ESTALE on directory traversal through deleted inode
has been added to the -mm tree.  Its filename is
     ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch

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
Subject: ext4: return -EIO not -ESTALE on directory traversal through deleted inode
From: Bryan Donlan <bdonlan@gmail.com>

ext4_iget() returns -ESTALE if invoked on a deleted inode, in order to
report errors to NFS properly.  However, in ext[234]_lookup(), this
-ESTALE can be propagated to userspace if the filesystem is corrupted such
that a directory entry references a deleted inode.  This leads to a
misleading error message - "Stale NFS file handle" - and confusion on the
part of the admin.

The bug can be easily reproduced by creating a new filesystem, making a
link to an unused inode using debugfs, then mounting and attempting to ls
-l said link.

This patch thus changes ext4_lookup to return -EIO if it receives -ESTALE
from ext4_iget(), as ext4 does for other filesystem metadata corruption;
and also invokes the appropriate ext*_error functions when this case is
detected.

Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/ext4/namei.c~ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode
+++ a/fs/ext4/namei.c
@@ -1051,8 +1051,16 @@ static struct dentry *ext4_lookup(struct
 			return ERR_PTR(-EIO);
 		}
 		inode = ext4_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+		if (unlikely(IS_ERR(inode))) {
+			if (PTR_ERR(inode) == -ESTALE) {
+				ext4_error(dir->i_sb, "ext2_lookup",
+						"deleted inode referenced: %u",
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

