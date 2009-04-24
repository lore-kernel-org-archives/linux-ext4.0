From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] EXT4:  Use is_power_of_2() routine for clarity.
Date: Fri, 24 Apr 2009 09:06:14 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0904240905050.12966@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@osdl.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:51867 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZDXNHM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2009 09:07:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2958f4e..479d5ef 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1479,7 +1479,7 @@ set_qf_format:
 				return 0;
 			if (option < 0 || option > (1 << 30))
 				return 0;
-			if (option & (option - 1)) {
+			if (!is_power_of_2(option)) {
 				printk(KERN_ERR "EXT4-fs: inode_readahead_blks"
 				       " must be a power of 2\n");
 				return 0;
@@ -2092,7 +2092,7 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 		return -EINVAL;

 	/* inode_readahead_blks must be a power of 2 */
-	if (t & (t-1))
+	if (!is_power_of_2(t))
 		return -EINVAL;

 	sbi->s_inode_readahead_blks = t;

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
