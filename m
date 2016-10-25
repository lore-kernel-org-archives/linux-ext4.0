From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: allow inode expansion for nojournal file systems
Date: Tue, 25 Oct 2016 17:14:05 -0400
Message-ID: <20161025211405.GA15502@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36826 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752476AbcJYVJU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Oct 2016 17:09:20 -0400
Received: by mail-qk0-f195.google.com with SMTP id z190so16536940qkc.3
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2016 14:09:19 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Runs of xfstest ext4/022 on nojournal file systems result in failures
because the inodes of some of its test files do not expand as expected.
The cause is a conditional in ext4_mark_inode_dirty() that prevents inode
expansion unless the test file system has a journal.  Remove this
unnecessary restriction.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/inode.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9c06472..260da4d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5455,18 +5455,20 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
 		return err;
-	if (ext4_handle_valid(handle) &&
-	    EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
+	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
 	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
 		/*
-		 * We need extra buffer credits since we may write into EA block
+		 * In nojournal mode, we can immediately attempt to expand
+		 * the inode.  When journaled, we first need to obtain extra
+		 * buffer credits since we may write into the EA block
 		 * with this same handle. If journal_extend fails, then it will
 		 * only result in a minor loss of functionality for that inode.
 		 * If this is felt to be critical, then e2fsck should be run to
 		 * force a large enough s_min_extra_isize.
 		 */
-		if ((jbd2_journal_extend(handle,
-			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb))) == 0) {
+		if (!ext4_handle_valid(handle) ||
+		    jbd2_journal_extend(handle,
+			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb)) == 0) {
 			ret = ext4_expand_extra_isize(inode,
 						      sbi->s_want_extra_isize,
 						      iloc, handle);
-- 
2.1.4

