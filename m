From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext2: reject inodes with negative size
Date: Tue, 6 Dec 2016 15:59:01 -0800
Message-ID: <20161206235901.GB16804@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23033 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbcLFX7L (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2016 18:59:11 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't load an inode with a negative size; this causes integer overflow
problems in the VFS.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext2/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 41b8b44..01f6d4b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1476,6 +1476,10 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		inode->i_size |= ((__u64)le32_to_cpu(raw_inode->i_size_high)) << 32;
 	else
 		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
+	if (i_size_read(inode) < 0) {
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 	ei->i_dtime = 0;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 	ei->i_state = 0;
