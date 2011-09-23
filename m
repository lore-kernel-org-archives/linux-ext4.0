From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] ext4/extents.c: quiet sparse noise about plain integer as NULL pointer
Date: Fri, 23 Sep 2011 15:32:44 -0700
Message-ID: <201109231532.44363.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail127.messagelabs.com ([216.82.250.115]:7688 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1IWWc4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 18:32:56 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The third parameter to ext4_free_blocks is a struct buffer_head *.  This
parameter should be NULL not 0.

This quiets the sparse noise:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..97e8d2b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2238,7 +2238,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		start = ext4_ext_pblock(ex);
 
 		ext_debug("free first %u blocks starting %llu\n", num, start);
-		ext4_free_blocks(handle, inode, 0, start, num, flags);
+		ext4_free_blocks(handle, inode, NULL, start, num, flags);
 
 	} else {
 		printk(KERN_INFO "strange request: removal(2) "
