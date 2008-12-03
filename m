From: <gregkh@suse.de>
Subject: patch ext4-fix-xattr-deadlock.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:55:58 -0800
Message-ID: <20081203185923.5150649048@coco.kroah.org>
References: <1226851540-8032-12-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: kalpak.shah@sun.com, gregkh@suse.de, linux-ext4@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60930 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751787AbYLCS7Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:24 -0500
In-Reply-To: <1226851540-8032-12-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: fix xattr deadlock

to the 2.6.27-stable tree.  Its filename is

    ext4-fix-xattr-deadlock.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:42:04 2008
From: Kalpak Shah <kalpak.shah@sun.com>
Date: Sun, 16 Nov 2008 11:05:31 -0500
Subject: ext4: fix xattr deadlock
To: stable@kernel.org
Cc: Kalpak Shah <kalpak.shah@sun.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-12-git-send-email-tytso@mit.edu>


From: Kalpak Shah <kalpak.shah@sun.com>

(cherry picked from commit 4d20c685fa365766a8f13584b4c8178a15ab7103)

ext4_xattr_set_handle() eventually ends up calling
ext4_mark_inode_dirty() which tries to expand the inode by shifting
the EAs.  This leads to the xattr_sem being downed again and leading
to a deadlock.

This patch makes sure that if ext4_xattr_set_handle() is in the
call-chain, ext4_mark_inode_dirty() will not expand the inode.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/xattr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -959,6 +959,7 @@ ext4_xattr_set_handle(handle_t *handle, 
 	struct ext4_xattr_block_find bs = {
 		.s = { .not_found = -ENODATA, },
 	};
+	unsigned long no_expand;
 	int error;
 
 	if (!name)
@@ -966,6 +967,9 @@ ext4_xattr_set_handle(handle_t *handle, 
 	if (strlen(name) > 255)
 		return -ERANGE;
 	down_write(&EXT4_I(inode)->xattr_sem);
+	no_expand = EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND;
+	EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
+
 	error = ext4_get_inode_loc(inode, &is.iloc);
 	if (error)
 		goto cleanup;
@@ -1042,6 +1046,8 @@ ext4_xattr_set_handle(handle_t *handle, 
 cleanup:
 	brelse(is.iloc.bh);
 	brelse(bs.bh);
+	if (no_expand == 0)
+		EXT4_I(inode)->i_state &= ~EXT4_STATE_NO_EXPAND;
 	up_write(&EXT4_I(inode)->xattr_sem);
 	return error;
 }


Patches currently in stable-queue which might be from kalpak.shah@sun.com are

queue-2.6.27/ext4-fix-xattr-deadlock.patch
