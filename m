From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: make online defrag error reporting consistent
Date: Wed, 17 Jun 2015 12:40:35 -0400
Message-ID: <20150617164035.GA1746@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:33531 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbbFQQkN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2015 12:40:13 -0400
Received: by qcbfz6 with SMTP id fz6so15428640qcb.0
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2015 09:40:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make the error reporting behavior resulting from the unsupported use
of online defrag on files with data journaling enabled consistent with
that implemented for bigalloc file systems. Difference found with
ext4/308.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/move_extent.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 8c04afb..fb6f117 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -571,12 +571,16 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
-	/* TODO: This is non obvious task to swap blocks for inodes with full
-	   jornaling enabled */
+
+	/* TODO: it's not obvious how to swap blocks for inodes with full
+	   journaling enabled */
 	if (ext4_should_journal_data(orig_inode) ||
 	    ext4_should_journal_data(donor_inode)) {
-		return -EINVAL;
+		ext4_msg(orig_inode->i_sb, KERN_ERR,
+			 "Online defrag not supported with data journaling");
+		return -EOPNOTSUPP;
 	}
+
 	/* Protect orig and donor inodes against a truncate */
 	lock_two_nondirectories(orig_inode, donor_inode);
 
-- 
2.1.4

