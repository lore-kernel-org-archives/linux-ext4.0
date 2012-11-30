From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ext4: remove unsafe and unnecessary memset()
Date: Fri, 30 Nov 2012 14:41:43 +0800
Message-ID: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50073 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2K3Glx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Nov 2012 01:41:53 -0500
Received: from /spool/local
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 30 Nov 2012 16:38:21 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAU6V6KT3015108
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 17:31:07 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAU6fmiQ022720
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2012 17:41:48 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We memset this page before checking whether it's valid. But we need
not memset zeroed page at all.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ad6cd8a..66a4e20 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3206,7 +3206,6 @@ int ext4_calculate_overhead(struct super_block *sb)
 	ext4_fsblk_t overhead = 0;
 	char *buf = (char *) get_zeroed_page(GFP_KERNEL);
 
-	memset(buf, 0, PAGE_SIZE);
 	if (!buf)
 		return -ENOMEM;
 
-- 
1.7.9.5

