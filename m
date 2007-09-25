From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 7/7] ext4: sparse fixes
Date: Tue, 25 Sep 2007 14:33:52 +0530
Message-ID: <11907111383002-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110501570-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110613446-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110772723-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907111031099-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907111281402-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:53893 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbXIYJGf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 05:06:35 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8P95uuF013501
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:56 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8P95slD3625088
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:54 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8P95sGA019098
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:55 +1000
In-Reply-To: <11907111281402-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/fsync.c |    2 +-
 fs/ext4/xattr.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 2a167d7..8d50879 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -47,7 +47,7 @@ int ext4_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	struct inode *inode = dentry->d_inode;
 	int ret = 0;
 
-	J_ASSERT(ext4_journal_current_handle() == 0);
+	J_ASSERT(ext4_journal_current_handle() == NULL);
 
 	/*
 	 * data=writeback:
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0fbaa0e..d796213 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1120,7 +1120,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	int total_ino, total_blk;
 	void *base, *start, *end;
 	int extra_isize = 0, error = 0, tried_min_extra_isize = 0;
-	int s_min_extra_isize = EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize;
+	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
 
 	down_write(&EXT4_I(inode)->xattr_sem);
 retry:
@@ -1292,7 +1292,7 @@ retry:
 
 		i.name = b_entry_name;
 		i.value = buffer;
-		i.value_len = cpu_to_le32(size);
+		i.value_len = size;
 		error = ext4_xattr_block_find(inode, &i, bs);
 		if (error)
 			goto cleanup;
-- 
1.5.3.1.91.gd3392-dirty
