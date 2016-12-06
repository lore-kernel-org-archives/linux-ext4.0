From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: reject inodes with negative size
Date: Tue, 6 Dec 2016 15:57:40 -0800
Message-ID: <20161206235740.GA16804@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16512 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbcLFX5p (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2016 18:57:45 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't load an inode with a negative size; this causes integer overflow
problems in the VFS.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9c06472..b1108a9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4534,6 +4534,10 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(raw_inode);
+	if (i_size_read(inode) < 0) {
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 	ei->i_disksize = inode->i_size;
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
