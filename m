From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: truncate block allocated on a failed ext4_write_begin
Date: Thu, 28 Aug 2008 22:57:51 +0530
Message-ID: <1219944473-8770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:46610 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753444AbYH1R2A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 13:28:00 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7SHRwc8004048
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:57:58 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SHRv201732760
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:57:57 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7SHRvHY010796
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:57:57 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For blocksize < pagesize we need to remove blocks that
got allocte in block_wirte_begin if we fail with ENOSPC
for later blocks. block_write_begin internally does
this if it allocated page locally. This make sure
we don't have blocks outisde inode.i_size during
ENOSPC

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 473d888..a8c6bc8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1394,6 +1394,13 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
  		unlock_page(page);
 		ext4_journal_stop(handle);
  		page_cache_release(page);
+		/*
+		 * block_write_begin may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
1.6.0.1.90.g27a6e

