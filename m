From: <gregkh@suse.de>
Subject: patch ext4-free-ext4_prealloc_space-using-kmem_cache_free.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:55:59 -0800
Message-ID: <20081203185924.984C249049@coco.kroah.org>
References: <1226851540-8032-13-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: aneesh.kumar@linux.vnet.ibm.com, gregkh@suse.de,
	linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752002AbYLCS7Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:25 -0500
In-Reply-To: <1226851540-8032-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Free ext4_prealloc_space using kmem_cache_free

to the 2.6.27-stable tree.  Its filename is

    ext4-free-ext4_prealloc_space-using-kmem_cache_free.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:42:23 2008
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Sun, 16 Nov 2008 11:05:32 -0500
Subject: ext4: Free ext4_prealloc_space using kmem_cache_free
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <1226851540-8032-13-git-send-email-tytso@mit.edu>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 688f05a01983711a4e715b1d6e15a89a89c96a66)

We should use kmem_cache_free to free memory allocated
via kmem_cache_alloc

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2577,7 +2577,7 @@ static void ext4_mb_cleanup_pa(struct ex
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
 		list_del(&pa->pa_group_list);
 		count++;
-		kfree(pa);
+		kmem_cache_free(ext4_pspace_cachep, pa);
 	}
 	if (count)
 		mb_debug("mballoc: %u PAs left\n", count);


Patches currently in stable-queue which might be from aneesh.kumar@linux.vnet.ibm.com are

queue-2.6.27/ext4-elevate-write-count-for-migrate-ioctl.patch
queue-2.6.27/ext4-free-ext4_prealloc_space-using-kmem_cache_free.patch
queue-2.6.27/ext4-do-mballoc-init-before-doing-filesystem-recovery.patch
queue-2.6.27/ext4-convert-to-host-order-before-using-the-values.patch
queue-2.6.27/ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-prepare_write.patch
