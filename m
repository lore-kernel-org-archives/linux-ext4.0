From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 20/24] ext4: Ignore i_file_acl_high unless EXT4_FEATURE_INCOMPAT_64BIT is present
Date: Tue,  2 Jun 2009 08:09:32 -0400
Message-ID: <1243944576-20915-20-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
 <1243944576-20915-13-git-send-email-tytso@mit.edu>
 <1243944576-20915-14-git-send-email-tytso@mit.edu>
 <1243944576-20915-15-git-send-email-tytso@mit.edu>
 <1243944576-20915-16-git-send-email-tytso@mit.edu>
 <1243944576-20915-17-git-send-email-tytso@mit.edu>
 <1243944576-20915-18-git-send-email-tytso@mit.edu>
 <1243944576-20915-19-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59256 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZFBMJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:45 -0400
In-Reply-To: <1243944576-20915-19-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't try to look at i_file_acl_high unless the INCOMPAT_64BIT feature
bit is set.  The field is normally zero, but older versions of e2fsck
didn't automatically check to make sure of this, so in the spirit of
"be liberal in what you accept", don't look at i_file_acl_high unless
we are using a 64-bit filesystem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit a9e817425dc0baede8ebe5fbc9984a640257432b)
---
 fs/ext4/inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 952ea94..0768859 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4064,11 +4064,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
 	inode->i_blocks = ext4_inode_blocks(raw_inode, ei);
 	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl_lo);
-	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
-	    cpu_to_le32(EXT4_OS_HURD)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT))
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
-	}
 	inode->i_size = ext4_isize(raw_inode);
 	ei->i_disksize = inode->i_size;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
-- 
1.6.3.1.1.g75fc.dirty

