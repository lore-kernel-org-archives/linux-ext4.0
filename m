From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 4/4] ext4: remove redundant initialization in ext4_fill_super()
Date: Fri, 30 Nov 2012 14:41:46 +0800
Message-ID: <1354257706-6582-4-git-send-email-yan@linux.vnet.ibm.com>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49498 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2K3Gl4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Nov 2012 01:41:56 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 30 Nov 2012 16:37:21 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAU6fpHo49479852
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 17:41:51 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAU6fpv9022854
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 17:41:51 +1100
In-Reply-To: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We use kzalloc() to allocate sbi, no need to zero its field.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 15d28e3..a99f6c7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3799,7 +3799,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
-	sbi->s_resize_flags = 0;
 
 	sb->s_root = NULL;
 
-- 
1.7.9.5

