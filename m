From: Bryan Donlan <bdonlan@gmail.com>
Subject: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory traversal through deleted inode
Date: Mon, 16 Feb 2009 20:10:03 -0500
Message-ID: <1234833003-19631-1-git-send-email-bdonlan@gmail.com>
References: <20090214141411.GD26628@mini-me.lan>
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	tytso@mit.edu, Bryan Donlan <bdonlan@gmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from satoko.is.fushizen.net ([207.192.69.114]:49642 "EHLO
	satoko.is.fushizen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZBQBKH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Feb 2009 20:10:07 -0500
In-Reply-To: <20090214141411.GD26628@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext[234]_iget() functions in the ext[234] family of filesystems returns
-ESTALE if invoked on a deleted inode, in order to report errors to NFS
properly. However, in ext[234]_lookup(), this -ESTALE can be propagated to
userspace if the filesystem is corrupted such that a directory entry
references a deleted inode. This leads to a misleading error message - "Stale
NFS file handle" - and confusion on the part of the admin.

The bug can be easily reproduced by creating a new filesystem, making a link
to an unused inode using debugfs, then mounting and attempting to ls -l
said link.

This patch thus changes ext[234]_lookup to return -EIO if it receives -ESTALE
from ext[234]_iget(), as ext[234] does for other filesystem metadata
corruption; and also invokes the appropriate ext*_error functions when
this case is detected.

Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
---
 fs/ext2/namei.c |   12 ++++++++++--
 fs/ext3/namei.c |   12 ++++++++++--
 fs/ext4/namei.c |   12 ++++++++++--
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 90ea179..e3d2d34 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -66,8 +66,16 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
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
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4db4ffa..7a99af0 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1047,8 +1047,16 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 			return ERR_PTR(-EIO);
 		}
 		inode = ext3_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+		if (unlikely(IS_ERR(inode))) {
+			if (PTR_ERR(inode) == -ESTALE) {
+				ext3_error(dir->i_sb, "ext2_lookup",
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
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ba702bd..a61637b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1052,8 +1052,16 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
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
-- 
1.5.6.3

