From: akpm@linux-foundation.org
Subject: [merged] ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch removed from -mm tree
Date: Thu, 26 Feb 2009 11:30:31 -0800
Message-ID: <200902261930.n1QJUVYU014434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: bdonlan@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: return -EIO not -ESTALE on directory traversal through deleted inode
has been removed from the -mm tree.  Its filename was
     ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+				ext4_error(dir->i_sb, __func__,
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

linux-next.patch
ext2-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch
ext3-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch

