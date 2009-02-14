From: d-email-bdonlan@fushizen.net
Subject: [RESEND/PATCH] ext[234]: Return -EIO not -ESTALE on directory traversal missing inode
Date: Sat, 14 Feb 2009 00:17:10 -0500
Message-ID: <1234588630-9380-1-git-send-email-d-email-bdonlan@fushizen.net>
References: <1234588099-8445-1-git-sen--dry-run>
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	tytso@mit.edu, Bryan Donlan <bdonlan@gmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from satoko.is.fushizen.net ([207.192.69.114]:58944 "EHLO
	satoko.is.fushizen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZBNFlN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Feb 2009 00:41:13 -0500
In-Reply-To: <1234588099-8445-1-git-sen--dry-run>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Bryan Donlan <bdonlan@gmail.com>

The ext[234]_iget() functions in the ext[234] family of filesystems returns
-ESTALE if invoked on a deleted inode, in order to report errors to NFS
properly. However, in ext[234]_lookup(), this -ESTALE can be propagated to
userspace if the filesystem is corrupted, and a inode is linked even
though it is marked as deleted. This leads to a misleading error message -
"Stale NFS file handle" - and confusion on the part of the admin.

The bug can be easily reproduced by creating a new filesystem, making a link
to an unused inode using debugfs, then mounting and attempting to ls -l
said link.

This patch thus changes ext[234]_lookup to return -EIO if it receives -ESTALE
from ext[234]_iget(), as ext[234] does for other filesystem metadata
corruption.

Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
---

Apologies for the resend so quickly for those on the CC list - my mailer was
misconfigured and the mail rejected by vger.

 fs/ext2/namei.c |    8 ++++++--
 fs/ext3/namei.c |    8 ++++++--
 fs/ext4/namei.c |    8 ++++++--
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 90ea179..7dab3e8 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -66,8 +66,12 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 	inode = NULL;
 	if (ino) {
 		inode = ext2_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+		if (unlikely(IS_ERR(inode))) {
+			if (PTR_ERR(inode) == -ESTALE)
+				return ERR_PTR(-EIO);
+			else
+				return ERR_CAST(inode);
+		}
 	}
 	return d_splice_alias(inode, dentry);
 }
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4db4ffa..625f5dc 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1047,8 +1047,12 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 			return ERR_PTR(-EIO);
 		}
 		inode = ext3_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+		if (unlikely(IS_ERR(inode))) {
+			if (PTR_ERR(inode) == -ESTALE)
+				return ERR_PTR(-EIO);
+			else
+				return ERR_CAST(inode);
+		}
 	}
 	return d_splice_alias(inode, dentry);
 }
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ba702bd..4b054b3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1052,8 +1052,12 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
 			return ERR_PTR(-EIO);
 		}
 		inode = ext4_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+		if (unlikely(IS_ERR(inode))) {
+			if (PTR_ERR(inode) == -ESTALE)
+				return ERR_PTR(-EIO);
+			else
+				return ERR_CAST(inode);
+		}
 	}
 	return d_splice_alias(inode, dentry);
 }
-- 
1.5.6.3

