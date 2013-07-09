From: Anatol Pomazau <anatol@google.com>
Subject: [PATCH] ext4: Rate limit printk in buffer_io_error()
Date: Tue,  9 Jul 2013 16:01:38 -0700
Message-ID: <1373410898-26826-1-git-send-email-anatol@google.com>
Cc: tytso@mit.edu, Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:32888 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3GIXBu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jul 2013 19:01:50 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so545334qen.5
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jul 2013 16:01:48 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Anatol Pomozov <anatol.pomozov@gmail.com>

If there are a lot of outstanding buffered IOs when a device is
taken offline (due to hardware errors etc), ext4_end_bio prints
out a message for each failed logical block. While this is desirable,
we see thousands of such lines being printed out before the
serial console gets overwhelmed, causing ext4_end_bio() wait for
the printk to complete.

This in itself isn't a disaster, except for the detail that this
function is being called with the queue lock held.
This causes any other function in the block layer
to spin on its spin_lock_irqsave while the serial console is
draining. If NMI watchdog is enabled on this machine then it
eventually comes along and shoots the machine in the head.

The end result is that losing any one disk causes the machine to
go down. This patch rate limits the printk to bandaid around the
problem.

Tested: xfstests
Change-Id: I8ab5690dcf4f3a67e78be147d45e489fdf4a88d8
Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 fs/ext4/page-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4acf1f7..4c9d5e7 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/ratelimit.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -214,7 +215,7 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 static void buffer_io_error(struct buffer_head *bh)
 {
 	char b[BDEVNAME_SIZE];
-	printk(KERN_ERR "Buffer I/O error on device %s, logical block %llu\n",
+	printk_ratelimited(KERN_ERR "Buffer I/O error on device %s, logical block %llu\n",
 			bdevname(bh->b_bdev, b),
 			(unsigned long long)bh->b_blocknr);
 }
-- 
1.8.3

