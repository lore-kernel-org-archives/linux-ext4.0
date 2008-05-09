From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH]fix  delalloc write_begin failure case
Date: Fri, 09 May 2008 16:45:25 -0700
Message-ID: <1210376725.3639.66.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40769 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627AbYEIXpj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 May 2008 19:45:39 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49Njbl1004189
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 19:45:37 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49NjbTs117350
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 19:45:37 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49NjaeW003678
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 19:45:36 -0400
Received: from [9.47.17.70] (w-ming-laptop.beaverton.ibm.com [9.47.17.70])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m49NjaZ9003667
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 19:45:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Need to unlock and release the page from page cache if the delalloc
write_begin failed.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.26-rc1/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-rc1.orig/fs/ext4/inode.c	2008-05-09 16:21:49.000000000 -0700
+++ linux-2.6.26-rc1/fs/ext4/inode.c	2008-05-09 16:25:26.000000000 -0700
@@ -1518,6 +1518,11 @@ static int ext4_da_write_begin(struct fi
 
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 							ext4_da_get_block_prep);
+	if (ret < 0) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+		
 	return ret;
 }
 


