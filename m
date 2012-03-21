From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/5] ext4: Allow punch hole beyond i_size
Date: Wed, 21 Mar 2012 08:23:56 +0100
Message-ID: <1332314639-22875-3-git-send-email-lczerner@redhat.com>
References: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2CUHYS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 03:24:18 -0400
In-Reply-To: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Allison Henderson <achender@linux.vnet.ibm.com>

From: Allison Henderson <achender@linux.vnet.ibm.com>

This patch allows blocks beyond i_size to be punched out.
This early return to catch this condition is simply removed
allowing punch hole to proceed beyond i_size.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7b822c0..7d4f2cb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4689,20 +4689,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t first_page_offset, last_page_offset;
 	int credits, err = 0;
 
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
