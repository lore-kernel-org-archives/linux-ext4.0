From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/5] ext4: Remove uneeded i_size handling
Date: Wed, 21 Mar 2012 08:23:57 +0100
Message-ID: <1332314639-22875-4-git-send-email-lczerner@redhat.com>
References: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2CUHYR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 03:24:17 -0400
In-Reply-To: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Allison Henderson <achender@linux.vnet.ibm.com>

From: Allison Henderson <achender@linux.vnet.ibm.com>

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
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7d4f2cb..846584d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4767,25 +4767,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 		}
 	}
 
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
