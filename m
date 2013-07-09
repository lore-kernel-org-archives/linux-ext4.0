From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] ext4: fix overflow when counting used blocks on 32-bit architectures
Date: Tue,  9 Jul 2013 10:39:32 -0400
Message-ID: <1373380772-16803-4-git-send-email-tytso@mit.edu>
References: <20130709143855.GF6000@thunk.org>
 <1373380772-16803-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36216 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab3GIOjf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jul 2013 10:39:35 -0400
In-Reply-To: <1373380772-16803-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

The arithmetics adding delalloc blocks to the number of used blocks in
ext4_getattr() can easily overflow on 32-bit archs as we first multiply
number of blocks by blocksize and then divide back by 512. Make the
arithmetics more clever and also use proper type (unsigned long long
instead of unsigned long).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0fca5a8..38f03dc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4702,7 +4702,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
 	struct inode *inode;
-	unsigned long delalloc_blocks;
+	unsigned long long delalloc_blocks;
 
 	inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
@@ -4720,7 +4720,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
 				EXT4_I(inode)->i_reserved_data_blocks);
 
-	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
+	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits-9);
 	return 0;
 }
 
-- 
1.7.12.rc0.22.gcdd159b

