From: dcg <diegocg@gmail.com>
Subject: [PATCH] Update Documentation/filesystems/ext4.txt
Date: Fri, 17 Oct 2008 01:10:08 +0200
Message-ID: <20081017011008.6c3b12ef@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:43291 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbYJPXJx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 19:09:53 -0400
Received: by ug-out-1314.google.com with SMTP id k3so1906127ugf.37
        for <linux-ext4@vger.kernel.org>; Thu, 16 Oct 2008 16:09:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since Ext4 is supposed to be stable in 2.6.28-rc, Documentation should be
updated...it needs more updates, of course, I don't really know what
parts should really be updated

PD: the wiki needs some update aswell.


Signed-off-by: Diego Calleja <diegocg@gmail.com>

Index: 2.6/Documentation/filesystems/ext4.txt
===================================================================
--- 2.6.orig/Documentation/filesystems/ext4.txt	2008-10-17 01:01:50.000000000 +0200
+++ 2.6/Documentation/filesystems/ext4.txt	2008-10-17 01:04:38.000000000 +0200
@@ -2,10 +2,10 @@
 Ext4 Filesystem
 ===============
 
-This is a development version of the ext4 filesystem, an advanced level
-of the ext3 filesystem which incorporates scalability and reliability
-enhancements for supporting large filesystems (64 bit) in keeping with
-increasing disk capacities and state-of-the-art feature requirements.
+Ext4 is an an advanced level of the ext3 filesystem which incorporates
+scalability and reliability enhancements for supporting large filesystems
+(64 bit) in keeping with increasing disk capacities and state-of-the-art
+feature requirements.
 
 Mailing list: linux-ext4@vger.kernel.org
 
@@ -40,7 +40,7 @@
     the test_fs flag to indicate that it's ok for an in-development
     filesystem to touch this filesystem:
 
-	# tune2fs -O extents -E test_fs /dev/hda1
+	# tune2fs -O extents /dev/hda1
 
     If the filesystem was created with 128 byte inodes, it can be
     converted to use 256 byte for greater efficiency via:
@@ -68,7 +68,7 @@
 
 2.1 Currently available
 
-* ability to use filesystems > 16TB (e2fsprogs support not available yet)
+* ability to use filesystems > 16TB
 * extent format reduces metadata overhead (RAM, IO for access, transactions)
 * extent format more robust in face of on-disk corruption due to magics,
 * internal redunancy in tree
@@ -101,12 +101,6 @@
 metadata checksumming have been discussed and planned for a bit but no patches
 exist yet so I'm not sure they're in the near-term roadmap.
 
-The big performance win will come with mballoc, delalloc and flex_bg
-grouping of bitmaps and inode tables.  Some test results available here:
-
- - http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.html
- - http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.html
