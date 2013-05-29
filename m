From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext4: Fix overflow when counting used blocks on 32-bit architectures
Date: Wed, 29 May 2013 14:05:33 +0200
Message-ID: <1369829133-4307-5-git-send-email-jack@suse.cz>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965833Ab3E2MFl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 May 2013 08:05:41 -0400
In-Reply-To: <1369829133-4307-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The arithmetics adding delalloc blocks to the number of used blocks in
ext4_getattr() can easily overflow on 32-bit archs as we first multiply
number of blocks by blocksize and then divide back by 512. Make the
arithmetics more clever and also use proper type (unsigned long long
instead of unsigned long).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d6382b8..83d9e69 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4805,7 +4805,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
 	struct inode *inode;
-	unsigned long delalloc_blocks;
+	unsigned long long delalloc_blocks;
 
 	inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
@@ -4823,7 +4823,7 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
 				EXT4_I(inode)->i_reserved_data_blocks);
 
-	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
+	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits-9);
 	return 0;
 }
 
-- 
1.8.1.4

