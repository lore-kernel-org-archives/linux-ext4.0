From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.29 03/18] ext4: return -EIO not -ESTALE on directory traversal through deleted inode
Date: Tue,  2 Jun 2009 08:07:44 -0400
Message-ID: <1243944479-20574-3-git-send-email-tytso@mit.edu>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
 <1243944479-20574-2-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Bryan Donlan <bdonlan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33515 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbZFBMIK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:08:10 -0400
In-Reply-To: <1243944479-20574-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Bryan Donlan <bdonlan@gmail.com>

ext4_iget() returns -ESTALE if invoked on a deleted inode, in order to
report errors to NFS properly.  However, in ext4_lookup(), this
-ESTALE can be propagated to userspace if the filesystem is corrupted
such that a directory entry references a deleted inode.  This leads to
a misleading error message - "Stale NFS file handle" - and confusion
on the part of the admin.

The bug can be easily reproduced by creating a new filesystem, making
a link to an unused inode using debugfs, then mounting and attempting
to ls -l said link.

This patch thus changes ext4_lookup to return -EIO if it receives
-ESTALE from ext4_iget(), as ext4 does for other filesystem metadata
corruption; and also invokes the appropriate ext*_error functions when
this case is detected.

Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit e6f009b0b45220c004672d41a58865e94946104d)
---
 fs/ext4/namei.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ba702bd..f787234 100644
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
-- 
1.6.3.1.1.g75fc.dirty

