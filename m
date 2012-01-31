From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: let getattr report the right blocks in delalloc+bigalloc.
Date: Tue, 31 Jan 2012 23:58:16 +0800
Message-ID: <1328025496-3521-1-git-send-email-tm@tao.ma>
Cc: sandeen@redhat.com, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:51353 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753506Ab2AaP6q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jan 2012 10:58:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In delayed allocation, i_reserved_data_blocks now indicates
clusters, not blocks. So report it in the right number.

This can be easily exposed by the following command:
echo foo > blah; du -hc blah; sync; du -hc blah

Cc: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..a5eb8c6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4200,7 +4200,8 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	 * will return the blocks that include the delayed allocation
 	 * blocks for this file.
 	 */
-	delalloc_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
+				EXT4_I(inode)->i_reserved_data_blocks);
 
 	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
 	return 0;
-- 
1.7.0.4

