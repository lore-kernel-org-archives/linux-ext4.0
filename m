From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ext4: Allow punch hole beyond i_size
Date: Sat, 14 Jan 2012 12:34:59 -0700
Message-ID: <1326569701-21620-2-git-send-email-achender@linux.vnet.ibm.com>
References: <1326569701-21620-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54734 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab2ANT3Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Jan 2012 14:29:24 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Sat, 14 Jan 2012 14:29:23 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0EJTHsB437450
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 14:29:17 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0EJTH6f025885
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 17:29:17 -0200
In-Reply-To: <1326569701-21620-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch allows blocks beyond i_size to be punched out.
This early return to catch this condition is simply removed
allowing punch hole to proceed beyond i_size.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 ad39627... 9ec6249... M	fs/ext4/extents.c
 fs/ext4/extents.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad39627..9ec6249 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4704,20 +4704,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t first_page_offset, last_page_offset;
 	int ret, credits, blocks_released, err = 0;
 
-	/* No need to punch hole beyond i_size */
-	if (offset >= inode->i_size)
-		return 0;
-
-	/*
-	 * If the hole extends beyond i_size, set the hole
-	 * to end after the page that contains i_size
-	 */
-	if (offset + length > inode->i_size) {
-		length = inode->i_size +
-		   PAGE_CACHE_SIZE - (inode->i_size & (PAGE_CACHE_SIZE - 1)) -
-		   offset;
-	}
