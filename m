From: <gregkh@suse.de>
Subject: patch ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch added to 2.6.29-stable tree
Date: Tue, 09 Jun 2009 02:33:04 -0700
Message-ID: <20090609094152.5146D48FA4@coco.kroah.org>
References: <1243944479-20574-3-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: bdonlan@gmail.com, akpm@linux-foundation.org, gregkh@suse.de,
	linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:46652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971AbZFIJlx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 05:41:53 -0400
In-Reply-To: <1243944479-20574-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: return -EIO not -ESTALE on directory traversal through deleted inode

to the 2.6.29-stable tree.  Its filename is

    ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org  Tue Jun  9 02:25:08 2009
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue,  2 Jun 2009 08:07:44 -0400
Subject: ext4: return -EIO not -ESTALE on directory traversal through deleted inode
To: stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Bryan Donlan <bdonlan@gmail.com>
Message-ID: <1243944479-20574-3-git-send-email-tytso@mit.edu>


From: Bryan Donlan <bdonlan@gmail.com>

(cherry picked from commit e6f009b0b45220c004672d41a58865e94946104d)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1052,8 +1052,16 @@ static struct dentry *ext4_lookup(struct
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


Patches currently in stable-queue which might be from bdonlan@gmail.com are

