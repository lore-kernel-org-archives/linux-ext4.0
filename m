From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Initialize fsync transaction ids in ext4_new_inode()
Date: Sun, 20 Mar 2011 19:47:30 -0400
Message-ID: <1300664850-11252-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59400 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab1CTXrf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2011 19:47:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When allocating a new inode, we need to make sure i_sync_tid and
i_datasync_tid are initialized.  Otherwise, one or both of these two
values could be left initialized to zero, which could potentially
result in BUG_ON in jbd2_journal_commit_transaction.

(This could happen by having journal->commit_request getting set to
zero, which could wake up the kjournald process even though there is
no running transaction, which then causes a BUG_ON via the
J_ASSERT(j_ruinning_transaction != NULL) statement.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ialloc.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2fd3b0e..a679a48 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1054,6 +1054,11 @@ got:
 		}
 	}
 
+	if (ext4_handle_valid(handle)) {
+		ei->i_sync_tid = handle->h_transaction->t_tid;
+		ei->i_datasync_tid = handle->h_transaction->t_tid;
+	}
+
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_std_error(sb, err);
-- 
1.7.3.1

