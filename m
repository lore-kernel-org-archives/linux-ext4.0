From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Don't update ctime for non-extent-mapped inodes
Date: Mon, 15 Jun 2009 03:43:19 -0400
Message-ID: <1245051799-12887-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54715 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZFOHny (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jun 2009 03:43:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The VFS handles updating ctime, so we don't need to update the inode's
ctime in ext4_splace_branch() to update the direct or indirect blocks.
This was harmless when we did this in ext3, but in ext4, thanks to
delayed allocation, updating the ctime in ext4_splice_branch() can
cause the ctime to mysteriously jump when the blocks are finally
allocated.

Thanks to Bj=C3=B6rn Steinbrink for pointing out this problem on the gi=
t
mailing list.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d0908a..7c17ae2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -856,10 +856,6 @@ static int ext4_splice_branch(handle_t *handle, st=
ruct inode *inode,
 	}
=20
 	/* We are done with atomic stuff, now do the rest of housekeeping */
-
-	inode->i_ctime =3D ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
