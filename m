From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ext4: Remove uneeded i_size handling
Date: Sat, 14 Jan 2012 12:35:00 -0700
Message-ID: <1326569701-21620-3-git-send-email-achender@linux.vnet.ibm.com>
References: <1326569701-21620-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51542 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab2ANT3X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Jan 2012 14:29:23 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Sat, 14 Jan 2012 14:29:22 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0EJTIlF437452
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 14:29:18 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0EJTIDh025909
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jan 2012 17:29:18 -0200
In-Reply-To: <1326569701-21620-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch removes a fix that is now being addressed in another
patch.  The code being removed also made the assumption that a
hole cannot exceed or start after i_size, but since this is no
longer the case and the source of the bug has been corrected in
a different patch, this code is no longer needed.

The removed code initally corrected a bug found in fsx,
where garbage data would appear in the last page after i_size, when
ever a hole ended in the same page as i_size.  The cause of the cause
of the garbage data has been fixed in patch
"[PATCH 2/2] ext4: let ext4_bio_write_page handle EOF correctly"

This patch set has been tested with fsx on a 1k block size, and
successfully passed 24 hours.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 9ec6249... e607880... M	fs/ext4/extents.c
 fs/ext4/extents.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9ec6249..e607880 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4786,26 +4786,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 		}
 	}
 
-
-	/*
-	 * If i_size is contained in the last page, we need to
-	 * unmap and zero the partial page after i_size
-	 */
-	if (inode->i_size >> PAGE_CACHE_SHIFT == last_page &&
-	   inode->i_size % PAGE_CACHE_SIZE != 0) {
-
-		page_len = PAGE_CACHE_SIZE -
-			(inode->i_size & (PAGE_CACHE_SIZE - 1));
-
-		if (page_len > 0) {
-			err = ext4_discard_partial_page_buffers(handle,
-			  mapping, inode->i_size, page_len, 0);
-
-			if (err)
-				goto out;
-		}
-	}
