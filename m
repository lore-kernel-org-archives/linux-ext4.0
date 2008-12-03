From: <gregkh@suse.de>
Subject: patch ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-prepare_write.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:00 -0800
Message-ID: <20081203185925.BB6104904A@coco.kroah.org>
References: <1226851540-8032-20-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: aneesh.kumar@linux.vnet.ibm.com, gregkh@suse.de,
	linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60936 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752037AbYLCS70 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:26 -0500
In-Reply-To: <1226851540-8032-20-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Mark the buffer_heads as dirty and uptodate after prepare_write

to the 2.6.27-stable tree.  Its filename is

    ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-prepare_write.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:44:57 2008
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Sun, 16 Nov 2008 11:05:39 -0500
Subject: ext4: Mark the buffer_heads as dirty and uptodate after prepare_write
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <1226851540-8032-20-git-send-email-tytso@mit.edu>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit ed9b3e3379731e9f9d2f73f3d7fd9e7d2ce3df4a)

We need to make sure we mark the buffer_heads as dirty and uptodate
so that block_write_full_page write them correctly.

This fixes mmap corruptions that can occur in low memory situations.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2242,6 +2242,8 @@ static int ext4_da_writepage(struct page
 			unlock_page(page);
 			return 0;
 		}
+		/* now mark the buffer_heads as dirty and uptodate */
+		block_commit_write(page, 0, PAGE_CACHE_SIZE);
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))


Patches currently in stable-queue which might be from aneesh.kumar@linux.vnet.ibm.com are

queue-2.6.27/ext4-elevate-write-count-for-migrate-ioctl.patch
queue-2.6.27/ext4-free-ext4_prealloc_space-using-kmem_cache_free.patch
queue-2.6.27/ext4-do-mballoc-init-before-doing-filesystem-recovery.patch
queue-2.6.27/ext4-convert-to-host-order-before-using-the-values.patch
queue-2.6.27/ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-prepare_write.patch
