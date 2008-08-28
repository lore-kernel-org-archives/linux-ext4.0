From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext3: truncate block allocated on a failed ext3_write_begin
Date: Thu, 28 Aug 2008 22:57:52 +0530
Message-ID: <1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219944473-8770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:43192 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754126AbYH1R2B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 13:28:01 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7SHRxl0020243
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:57:59 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SHRx7h1519740
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:57:59 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7SHRwIt010825
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 22:57:59 +0530
In-Reply-To: <1219944473-8770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
 fs/ext3/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index ebfec4d..f8424ad 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1186,6 +1186,13 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
 		ext3_journal_stop(handle);
 		unlock_page(page);
 		page_cache_release(page);
+		/*
+		 * block_write_begin may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
-- 
1.6.0.1.90.g27a6e

