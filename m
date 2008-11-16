From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 11/20] ext4: fix xattr deadlock
Date: Sun, 16 Nov 2008 11:05:31 -0500
Message-ID: <1226851540-8032-12-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
 <1226851540-8032-9-git-send-email-tytso@mit.edu>
 <1226851540-8032-10-git-send-email-tytso@mit.edu>
 <1226851540-8032-11-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kalpak Shah <kalpak.shah@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44721 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421AbYKPQhC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:37:02 -0500
In-Reply-To: <1226851540-8032-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Kalpak Shah <kalpak.shah@sun.com>

ext4_xattr_set_handle() eventually ends up calling
ext4_mark_inode_dirty() which tries to expand the inode by shifting
the EAs.  This leads to the xattr_sem being downed again and leading
to a deadlock.

This patch makes sure that if ext4_xattr_set_handle() is in the
call-chain, ext4_mark_inode_dirty() will not expand the inode.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 4d20c685fa365766a8f13584b4c8178a15ab7103)
---
 fs/ext4/xattr.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 8954208..362b0ed 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -959,6 +959,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	struct ext4_xattr_block_find bs = {
 		.s = { .not_found = -ENODATA, },
 	};
+	unsigned long no_expand;
 	int error;
 
 	if (!name)
@@ -966,6 +967,9 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	if (strlen(name) > 255)
 		return -ERANGE;
 	down_write(&EXT4_I(inode)->xattr_sem);
+	no_expand = EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND;
+	EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
+
 	error = ext4_get_inode_loc(inode, &is.iloc);
 	if (error)
 		goto cleanup;
@@ -1042,6 +1046,8 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 cleanup:
 	brelse(is.iloc.bh);
 	brelse(bs.bh);
+	if (no_expand == 0)
+		EXT4_I(inode)->i_state &= ~EXT4_STATE_NO_EXPAND;
 	up_write(&EXT4_I(inode)->xattr_sem);
 	return error;
 }
-- 
1.6.0.4.8.g36f27.dirty

