From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Update Documentation/filesystems/ext4.txt
Date: Fri, 17 Oct 2008 07:11:57 -0400
Message-ID: <20081017111157.GA21503@mit.edu>
References: <20081017011008.6c3b12ef@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: dcg <diegocg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54540 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752506AbYJQLL7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 07:11:59 -0400
Content-Disposition: inline
In-Reply-To: <20081017011008.6c3b12ef@diego-desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 01:10:08AM +0200, dcg wrote:
> Since Ext4 is supposed to be stable in 2.6.28-rc, Documentation should be
> updated...it needs more updates, of course, I don't really know what
> parts should really be updated

Thanks, here's the revised version of the patch which I have in the
ext4 patch queue.

> PD: the wiki needs some update aswell.

I'll update the wiki after 2.6.28-rc1 and the merge window closes.

     	    	     	   	      	      - Ted

ext4: Update Documentation/filesystems/ext4.txt

From: dcg <diegocg@gmail.com>

Since Ext4 is supposed to be stable in 2.6.28-rc, ext4's documentation
file should be updated.

[ More updates also added by Theodore Ts'o. ]

Signed-off-by: Diego Calleja <diegocg@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


Index: 2.6/Documentation/filesystems/ext4.txt
===================================================================
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index eb154ef..7fd9b9b 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
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
 
@@ -14,7 +14,7 @@ Mailing list: linux-ext4@vger.kernel.org
 ===========================
 
   - Compile and install the latest version of e2fsprogs (as of this
-    writing version 1.41) from:
+    writing version 1.41.3) from:
 
     http://sourceforge.net/project/showfiles.php?group_id=2406
 	
@@ -36,11 +36,9 @@ Mailing list: linux-ext4@vger.kernel.org
 
     	# mke2fs -t ext4 /dev/hda1
 
-    Or configure an existing ext3 filesystem to support extents and set
-    the test_fs flag to indicate that it's ok for an in-development
-    filesystem to touch this filesystem:
+    Or to configure an existing ext3 filesystem to support extents: 
 
-	# tune2fs -O extents -E test_fs /dev/hda1
+	# tune2fs -O extents /dev/hda1
 
     If the filesystem was created with 128 byte inodes, it can be
     converted to use 256 byte for greater efficiency via:
@@ -104,8 +102,8 @@ exist yet so I'm not sure they're in the near-term roadmap.
 The big performance win will come with mballoc, delalloc and flex_bg
 grouping of bitmaps and inode tables.  Some test results available here:
 
- - http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.html
- - http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.html
+ - http://www.bullopensource.org/ext4/20080818-ffsb/ffsb-write-2.6.27-rc1.html
+ - http://www.bullopensource.org/ext4/20080818-ffsb/ffsb-readwrite-2.6.27-rc1.html
 
 3. Options
 ==========
@@ -253,8 +251,6 @@ nobh			(a) cache disk block mapping information
 			"nobh" option tries to avoid associating buffer
 			heads (supported only for "writeback" mode).
 
-mballoc		(*)	Use the multiple block allocator for block allocation
-nomballoc		disabled multiple block allocator for block allocation.
 stripe=n		Number of filesystem blocks that mballoc will try
 			to use for allocation size and alignment. For RAID5/6
 			systems this should be the number of data
