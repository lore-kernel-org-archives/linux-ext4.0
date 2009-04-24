From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Do not try to validate extents on special files
Date: Fri, 24 Apr 2009 18:54:39 -0400
Message-ID: <1240613679-28208-1-git-send-email-tytso@mit.edu>
References: <20090424205927.GA13608@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36079 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZDXWym (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 18:54:42 -0400
In-Reply-To: <20090424205927.GA13608@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The EXTENTS_FL flag should never be set on special files, but if it
is, don't bother trying to validate that the extents tree is valid,
since only files, directories, and non-fast symlinks will ever have an
extent data structure.  We perhaps should flag the filesystem as being
corrupted if we see a special file (named pipes, device nodes, Unix
domain sockets, etc.) with the EXTENTS_FL flag, but e2fsck doesn't
currently check this case, so we'll just ignore this for now, since
it's harmless.

Without this fix, a special device with the extents flag is flagged as
an error by the kernel, so it is impossible to access or delete the
inode, but e2fsck doesn't see it as a problem, leading to
confused/frustrated users.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1146003..e91f978 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4407,6 +4407,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
 	}
 
+	ret = 0;
 	if (ei->i_file_acl &&
 	    ((ei->i_file_acl < 
 	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
@@ -4418,8 +4419,11 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		ret = -EIO;
 		goto bad_inode;
 	} else if (ei->i_flags & EXT4_EXTENTS_FL) {
-		/* Validate extent which is part of inode */
-		ret = ext4_ext_check_inode(inode);
+		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
+		    (S_ISLNK(inode->i_mode) &&
+		     !ext4_inode_is_fast_symlink(inode)))
+			/* Validate extent which is part of inode */
+			ret = ext4_ext_check_inode(inode);
  	} else if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 		   (S_ISLNK(inode->i_mode) &&
 		    !ext4_inode_is_fast_symlink(inode))) {
-- 
1.5.6.3

