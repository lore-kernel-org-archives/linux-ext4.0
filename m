From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
Subject: [PATCH] [TRIVIAL] ext*: spelling fix prefered -> preferred
Date: Wed, 19 Mar 2008 21:23:19 +0100
Message-ID: <20080319202319.GD6935@ens-lyon.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	trivial@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pilet.ens-lyon.fr ([140.77.167.16]:42387 "EHLO
	pilet.ens-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763136AbYCSU5U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 16:57:20 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Spelling fix: prefered -> preferred

Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>

diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext2/ialloc.c
--- a/fs/ext2/ialloc.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/fs/ext2/ialloc.c	Wed Mar 19 21:01:45 2008 +0100
@@ -253,7 +253,7 @@
  * it has too few free inodes left (min_inodes) or 
  * it has too few free blocks left (min_blocks) or 
  * it's already running too large debt (max_debt). 
- * Parent's group is prefered, if it doesn't satisfy these 
+ * Parent's group is preferred, if it doesn't satisfy these 
  * conditions we search cyclically through the rest. If none 
  * of the groups look good we just look for a group with more 
  * free inodes than average (starting at parent's group). 
diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext2/inode.c
--- a/fs/ext2/inode.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/fs/ext2/inode.c	Wed Mar 19 21:01:45 2008 +0100
@@ -239,7 +239,7 @@
  *	@inode: owner
  *	@ind: descriptor of indirect block.
  *
- *	This function returns the prefered place for block allocation.
+ *	This function returns the preferred place for block allocation.
  *	It is used when heuristic for sequential allocation fails.
  *	Rules are:
  *	  + if there is a block to the left of our position - allocate near it.
@@ -283,7 +283,7 @@
 }
 
 /**
- *	ext2_find_goal - find a prefered place for allocation.
+ *	ext2_find_goal - find a preferred place for allocation.
  *	@inode: owner
  *	@block:  block we want
  *	@partial: pointer to the last triple within a chain
diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/fs/ext3/ialloc.c	Wed Mar 19 21:01:45 2008 +0100
@@ -239,7 +239,7 @@
  * it has too few free inodes left (min_inodes) or
  * it has too few free blocks left (min_blocks) or
  * it's already running too large debt (max_debt).
- * Parent's group is prefered, if it doesn't satisfy these
+ * Parent's group is preferred, if it doesn't satisfy these
  * conditions we search cyclically through the rest. If none
  * of the groups look good we just look for a group with more
  * free inodes than average (starting at parent's group).
diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext3/inode.c
--- a/fs/ext3/inode.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/fs/ext3/inode.c	Wed Mar 19 21:01:45 2008 +0100
@@ -392,7 +392,7 @@
  *	@inode: owner
  *	@ind: descriptor of indirect block.
  *
- *	This function returns the prefered place for block allocation.
+ *	This function returns the preferred place for block allocation.
  *	It is used when heuristic for sequential allocation fails.
  *	Rules are:
  *	  + if there is a block to the left of our position - allocate near it.
@@ -436,12 +436,12 @@
 }
 
 /**
- *	ext3_find_goal - find a prefered place for allocation.
+ *	ext3_find_goal - find a preferred place for allocation.
  *	@inode: owner
  *	@block:  block we want
  *	@partial: pointer to the last triple within a chain
  *
- *	Normally this function find the prefered place for block allocation,
+ *	Normally this function find the preferred place for block allocation,
  *	returns it.
  */
 
diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/fs/ext4/ialloc.c	Wed Mar 19 21:01:45 2008 +0100
@@ -305,7 +305,7 @@
  * it has too few free inodes left (min_inodes) or
  * it has too few free blocks left (min_blocks) or
  * it's already running too large debt (max_debt).
- * Parent's group is prefered, if it doesn't satisfy these
+ * Parent's group is preferred, if it doesn't satisfy these
  * conditions we search cyclically through the rest. If none
  * of the groups look good we just look for a group with more
  * free inodes than average (starting at parent's group).
diff -r 2202c155b8c3 -r ef957e3033e5 fs/ext4/inode.c
--- a/fs/ext4/inode.c	Tue Mar 18 21:34:48 2008 -0700
+++ b/fs/ext4/inode.c	Wed Mar 19 21:01:45 2008 +0100
@@ -382,7 +382,7 @@
  *	@inode: owner
  *	@ind: descriptor of indirect block.
  *
- *	This function returns the prefered place for block allocation.
+ *	This function returns the preferred place for block allocation.
  *	It is used when heuristic for sequential allocation fails.
  *	Rules are:
  *	  + if there is a block to the left of our position - allocate near it.
@@ -432,12 +432,12 @@
 }
 
 /**
- *	ext4_find_goal - find a prefered place for allocation.
+ *	ext4_find_goal - find a preferred place for allocation.
  *	@inode: owner
  *	@block:  block we want
  *	@partial: pointer to the last triple within a chain
  *
- *	Normally this function find the prefered place for block allocation,
+ *	Normally this function find the preferred place for block allocation,
  *	returns it.
  */
 static ext4_fsblk_t ext4_find_goal(struct inode *inode, ext4_lblk_t block,

-- 
:wq
