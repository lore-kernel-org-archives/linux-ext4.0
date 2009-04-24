From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Ignore i_file_acl_high unless EXT4_FEATURE_INCOMPAT_64BIT is present
Date: Fri, 24 Apr 2009 16:45:57 -0400
Message-ID: <1240605957-13512-2-git-send-email-tytso@mit.edu>
References: <1240605957-13512-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43788 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbZDXUqG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 16:46:06 -0400
In-Reply-To: <1240605957-13512-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't try to look at i_file_acl_high unless the INCOMPAT_64BIT feature
bit is set.  The field is normally zero, but older versions of e2fsck
didn't automatically check to make sure of this, so in the spirit of
"be liberal in what you accept", don't look at i_file_acl_high unless
we are using a 64-bit filesystem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cab75bb..1146003 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4357,11 +4357,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
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
1.5.6.3

