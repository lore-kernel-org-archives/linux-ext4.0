From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: enforce online defrag restriction for encrypted files
Date: Fri, 22 Jul 2016 18:17:55 -0400
Message-ID: <20160722221755.GA1594@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35117 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbcGVWOs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jul 2016 18:14:48 -0400
Received: by mail-qk0-f193.google.com with SMTP id q62so9526274qkf.2
        for <linux-ext4@vger.kernel.org>; Fri, 22 Jul 2016 15:14:47 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Online defragging of encrypted files is not currently implemented.
However, the move extent ioctl can still return successfully when
called.  For example, this occurs when xfstest ext4/020 is run on an
encrypted file system, resulting in a corrupted test file and a
corresponding test failure.

Until the proper functionality is implemented, fail the move extent
ioctl if either the original or donor file is encrypted.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/move_extent.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index a920c5d..6fc14de 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -598,6 +598,13 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 		return -EOPNOTSUPP;
 	}
 
+	if (ext4_encrypted_inode(orig_inode) ||
+	    ext4_encrypted_inode(donor_inode)) {
+		ext4_msg(orig_inode->i_sb, KERN_ERR,
+			 "Online defrag not supported for encrypted files");
+		return -EOPNOTSUPP;
+	}
+
 	/* Protect orig and donor inodes against a truncate */
 	lock_two_nondirectories(orig_inode, donor_inode);
 
-- 
2.1.4

