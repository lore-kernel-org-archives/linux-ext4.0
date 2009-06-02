From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.29 13/18] ext4: Fix softlockup caused by illegal i_file_acl value in on-disk inode
Date: Tue,  2 Jun 2009 08:07:54 -0400
Message-ID: <1243944479-20574-13-git-send-email-tytso@mit.edu>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
 <1243944479-20574-2-git-send-email-tytso@mit.edu>
 <1243944479-20574-3-git-send-email-tytso@mit.edu>
 <1243944479-20574-4-git-send-email-tytso@mit.edu>
 <1243944479-20574-5-git-send-email-tytso@mit.edu>
 <1243944479-20574-6-git-send-email-tytso@mit.edu>
 <1243944479-20574-7-git-send-email-tytso@mit.edu>
 <1243944479-20574-8-git-send-email-tytso@mit.edu>
 <1243944479-20574-9-git-send-email-tytso@mit.edu>
 <1243944479-20574-10-git-send-email-tytso@mit.edu>
 <1243944479-20574-11-git-send-email-tytso@mit.edu>
 <1243944479-20574-12-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33528 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZFBMIK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:08:10 -0400
In-Reply-To: <1243944479-20574-12-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the block containing external extended attributes (which is stored
in i_file_acl and i_file_acl_high) is larger than the on-disk
filesystem, the process which tried to access the extended attributes
will endlessly issue kernel printks complaining that
"__find_get_block_slow() failed", locking up that CPU until the system
is forcibly rebooted.

So when we read in the inode, make sure the i_file_acl value is legal,
and if not, flag the filesystem as being corrupted.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 485c26ec70f823f2a9cf45982b724893e53a859e)
---
 fs/ext4/inode.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c4f0e14..ec3457b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4351,6 +4351,18 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
 	}
 
+	if (ei->i_file_acl &&
+	    ((ei->i_file_acl < 
+	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
+	       EXT4_SB(sb)->s_gdb_count)) ||
+	     (ei->i_file_acl >= ext4_blocks_count(EXT4_SB(sb)->s_es)))) {
+		ext4_error(sb, __func__,
+			   "bad extended attribute block %llu in inode #%lu",
+			   ei->i_file_acl, inode->i_ino);
+		ret = -EIO;
+		goto bad_inode;
+	}
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
-- 
1.6.3.1.1.g75fc.dirty

