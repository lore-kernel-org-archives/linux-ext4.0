From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 35/42] ext4: fix xattr deadlock
Date: Thu,  9 Oct 2008 00:05:53 -0400
Message-ID: <1223525160-9887-36-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
 <1223525160-9887-19-git-send-email-tytso@mit.edu>
 <1223525160-9887-20-git-send-email-tytso@mit.edu>
 <1223525160-9887-21-git-send-email-tytso@mit.edu>
 <1223525160-9887-22-git-send-email-tytso@mit.edu>
 <1223525160-9887-23-git-send-email-tytso@mit.edu>
 <1223525160-9887-24-git-send-email-tytso@mit.edu>
 <1223525160-9887-25-git-send-email-tytso@mit.edu>
 <1223525160-9887-26-git-send-email-tytso@mit.edu>
 <1223525160-9887-27-git-send-email-tytso@mit.edu>
 <1223525160-9887-28-git-send-email-tytso@mit.edu>
 <1223525160-9887-29-git-send-email-tytso@mit.edu>
 <1223525160-9887-30-git-send-email-tytso@mit.edu>
 <1223525160-9887-31-git-send-email-tytso@mit.edu>
 <1223525160-9887-32-git-send-email-tytso@mit.edu>
 <1223525160-9887-33-git-send-email-tytso@mit.edu>
 <1223525160-9887-34-git-send-email-tytso@mit.edu>
 <1223525160-9887-35-git-send-email-tytso@mit.edu>
Cc: Kalpak Shah <kalpak.shah@sun.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54530 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757601AbYJIEGN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:13 -0400
In-Reply-To: <1223525160-9887-35-git-send-email-tytso@mit.edu>
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
1.5.6.1.205.ge2c7.dirty

