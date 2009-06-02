From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 08/24] ext4: return -EIO not -ESTALE on directory traversal through deleted inode
Date: Tue,  2 Jun 2009 08:09:20 -0400
Message-ID: <1243944576-20915-8-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Bryan Donlan <bdonlan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59290 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZFBMJs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:48 -0400
In-Reply-To: <1243944576-20915-7-git-send-email-tytso@mit.edu>
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
index 4f3628f..e2028b3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1055,8 +1055,16 @@ static struct dentry *ext4_lookup(struct inode * dir, struct dentry *dentry, str
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

