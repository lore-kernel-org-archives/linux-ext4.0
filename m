From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Drop mapped buffer_head check during page_mkwrite
Date: Tue, 25 Aug 2009 19:52:59 +0530
Message-ID: <1251210179-7634-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:46723 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbZHYOXE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 10:23:04 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp09.in.ibm.com (8.14.3/8.13.1) with ESMTP id n7PEN13Y008385
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 19:53:01 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7PEN3cN974948
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 19:53:03 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n7PEN3sa018543
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 19:53:03 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inorder to check whether the buffer_heads are mapped we need
to hold page lock. Otherwise a reclaim can cleanup the attached
buffer_heads. Instead of taking page lock and check whether
buffer_heads are mapped we let the write_begin/write_end callback
does the equivalent. It does have a performance impact in that we
are doing more work if we the buffer_heads are already mapped.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9c642b..d40b97d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5281,12 +5281,6 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	else
 		len = PAGE_CACHE_SIZE;
 
-	if (page_has_buffers(page)) {
-		/* return if we have all the buffers mapped */
-		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-				       ext4_bh_unmapped))
-			goto out_unlock;
-	}
 	/*
 	 * OK, we need to fill the hole... Do write_begin write_end
 	 * to do block allocation/reservation.We are not holding
-- 
1.6.4.1.174.g32f4c

