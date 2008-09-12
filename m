From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Update for patches in patch queue
Date: Fri, 12 Sep 2008 14:32:28 +0530
Message-ID: <1221210148-26329-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1221210148-26329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1221210148-26329-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:52703 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752233AbYILJDe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:03:34 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m8C93UOV026601
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:33:30 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C935551380536
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:33:30 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m8C935OF002329
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:03:05 +1000
In-Reply-To: <1221210148-26329-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

For blocksize < pagesize we need to remove blocks that
got allocte in block_wirte_begin if we fail with ENOSPC
for later blocks. block_write_begin internally does
this if it allocated page locally. This make sure
we don't have blocks outisde inode.i_size during
ENOSPC

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 48534be..e7c84e4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1391,6 +1391,13 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
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
@@ -2560,6 +2567,13 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
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
