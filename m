From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: ext4_forget() must treat directory or symlink blocks as metadata
Date: Sun, 15 Nov 2009 15:48:45 -0500
Message-ID: <1258318125-23703-1-git-send-email-tytso@mit.edu>
References: <20091115204346.GE4323@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42957 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZKOUsn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 15:48:43 -0500
In-Reply-To: <20091115204346.GE4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a directory gets unlinked, ext4_forget() is called on any buffer
heads corresponding to its data blocks.  Data blocks from directories
must be treated as metadata, so that they are revoked by
jbd2_journal_revoke, and not just forgotten via ext4_journal_forget().

Thanks to Curt Wohlgemuth for pointing out potential problems in this
area.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 13de1dd..24729ed 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -97,6 +97,10 @@ int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
 
+	/* Directory or symlink blocks must be treated as metadata */
+	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
+		is_metadata = 1;
+
 	/* Never use the revoke function if we are doing full data
 	 * journaling: there is no need to, and a V1 superblock won't
 	 * support it.  Otherwise, only skip the revoke on un-journaled
-- 
1.6.5.216.g5288a.dirty

