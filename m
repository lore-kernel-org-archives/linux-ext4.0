From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ext4: use sync_inode_metadata() when sync inode metadata
Date: Fri, 30 Nov 2012 14:41:44 +0800
Message-ID: <1354257706-6582-2-git-send-email-yan@linux.vnet.ibm.com>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49493 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2K3Gly (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Nov 2012 01:41:54 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 30 Nov 2012 16:37:17 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAU6V7dH1442254
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 17:31:07 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAU6fnPx022758
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 17:41:49 +1100
In-Reply-To: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have a dedicated interface to sync inode metadata.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/fsync.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index be1d89f..dfbc1fe 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -44,7 +44,6 @@
  */
 static int ext4_sync_parent(struct inode *inode)
 {
-	struct writeback_control wbc;
 	struct dentry *dentry = NULL;
 	struct inode *next;
 	int ret = 0;
@@ -66,10 +65,7 @@ static int ext4_sync_parent(struct inode *inode)
 		ret = sync_mapping_buffers(inode->i_mapping);
 		if (ret)
 			break;
-		memset(&wbc, 0, sizeof(wbc));
-		wbc.sync_mode = WB_SYNC_ALL;
-		wbc.nr_to_write = 0;         /* only write out the inode */
-		ret = sync_inode(inode, &wbc);
+		ret = sync_inode_metadata(inode, 1);
 		if (ret)
 			break;
 	}
-- 
1.7.9.5

