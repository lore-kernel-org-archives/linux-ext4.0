From: <gregkh@suse.de>
Subject: patch ext4-convert-to-host-order-before-using-the-values.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:55:50 -0800
Message-ID: <20081203185915.1EE4C49042@coco.kroah.org>
References: <1226851540-8032-17-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: aneesh.kumar@linux.vnet.ibm.com, gregkh@suse.de,
	linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822AbYLCS7P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:15 -0500
In-Reply-To: <1226851540-8032-17-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Convert to host order before using the values.

to the 2.6.27-stable tree.  Its filename is

    ext4-convert-to-host-order-before-using-the-values.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 10:43:46 2008
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Sun, 16 Nov 2008 11:05:36 -0500
Subject: ext4: Convert to host order before using the values.
To: stable@kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <1226851540-8032-17-git-send-email-tytso@mit.edu>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit d94e99a64c3beece22dbfb2b335771a59184eb0a)

Use le16_to_cpu to read the s_reserved_gdt_blocks values
from super block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1506,9 +1506,8 @@ static int ext4_fill_flex_info(struct su
 
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
-			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
-			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
-			   groups_per_flex;
+			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
+			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {


Patches currently in stable-queue which might be from aneesh.kumar@linux.vnet.ibm.com are

queue-2.6.27/ext4-elevate-write-count-for-migrate-ioctl.patch
queue-2.6.27/ext4-free-ext4_prealloc_space-using-kmem_cache_free.patch
queue-2.6.27/ext4-do-mballoc-init-before-doing-filesystem-recovery.patch
queue-2.6.27/ext4-convert-to-host-order-before-using-the-values.patch
queue-2.6.27/ext4-mark-the-buffer_heads-as-dirty-and-uptodate-after-prepare_write.patch
