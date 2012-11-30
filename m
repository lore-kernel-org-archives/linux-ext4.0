From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ext4: remove redundant code in ext4_alloc_inode()
Date: Fri, 30 Nov 2012 14:41:45 +0800
Message-ID: <1354257706-6582-3-git-send-email-yan@linux.vnet.ibm.com>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60818 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab2K3GmG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Nov 2012 01:42:06 -0500
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 30 Nov 2012 16:40:56 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAU6Ux8L35192930
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 17:30:59 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAU6foae022795
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 17:41:50 +1100
In-Reply-To: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

inode_init_always() will initialize inode->i_data.writeback_index
anyway, no need to do this in ext4_alloc_inode().

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 66a4e20..15d28e3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -940,7 +940,6 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	ei->vfs_inode.i_version = 1;
-	ei->vfs_inode.i_data.writeback_index = 0;
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
-- 
1.7.9.5

