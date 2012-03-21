From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/5] ext4: Correct ext4_punch_hole return codes
Date: Wed, 21 Mar 2012 08:23:58 +0100
Message-ID: <1332314639-22875-5-git-send-email-lczerner@redhat.com>
References: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab2CUHYT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 03:24:19 -0400
In-Reply-To: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Allison Henderson <achender@linux.vnet.ibm.com>

From: Allison Henderson <achender@linux.vnet.ibm.com>

ext4_punch_hole returns -ENOTSUPP but it should be using
-EOPNOTSUPP

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 55f5b91..d54143a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3329,16 +3329,16 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
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
1.7.4.4

