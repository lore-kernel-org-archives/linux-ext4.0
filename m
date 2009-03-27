From: Dan Carpenter <error27@gmail.com>
Subject: [patch] ext4: typo leads to small leak
Date: Fri, 27 Mar 2009 13:36:49 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0809291437490.14101@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:29210 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbZC0KjS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Mar 2009 06:39:18 -0400
Received: by fg-out-1718.google.com with SMTP id 16so8047fgg.17
        for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2009 03:39:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was found by smatch (http://repo.or.cz/w/smatch.git/)

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/ext4/mballoc.c	2009-03-26 18:22:30.000000000 +0300
+++ devel/fs/ext4/mballoc.c	2009-03-26 18:22:56.000000000 +0300
@@ -2693,7 +2693,7 @@
 	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned int);
 	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_mb_maxs == NULL) {
-		kfree(sbi->s_mb_maxs);
+		kfree(sbi->s_mb_offsets);
 		return -ENOMEM;
 	}
 
