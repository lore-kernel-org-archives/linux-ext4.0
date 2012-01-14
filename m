From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ext4: Correct ext4_punch_hole return codes
Date: Sat, 14 Jan 2012 12:35:01 -0700
Message-ID: <1326569701-21620-4-git-send-email-achender@linux.vnet.ibm.com>
References: <1326569701-21620-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54735 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab2ANT3Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Jan 2012 14:29:24 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Sat, 14 Jan 2012 14:29:24 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0EJTJlJ228330
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 14:29:19 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0EJTJ85025948
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 17:29:19 -0200
In-Reply-To: <1326569701-21620-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_punch_hole returns -ENOTSUPP but it should
be using -EOPNOTSUPP

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 1380cd2... 38d8022... M	fs/ext4/inode.c
 fs/ext4/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1380cd2..38d8022 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3466,16 +3466,16 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	if (!S_ISREG(inode->i_mode))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		/* TODO: Add support for non extent hole punching */
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) {
 		/* TODO: Add support for bigalloc file systems */
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	return ext4_ext_punch_hole(file, offset, length);
-- 
1.7.1

