From: Mingming <cmm@us.ibm.com>
Subject: [PATCH 4/4 v2] Fix direct IO return values over fullfilled
 fallocate space
Date: Thu, 08 Oct 2009 18:13:12 -0700
Message-ID: <1255050792.4931.185.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:58760 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbZJIBNy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2009 21:13:54 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9917W9u019483
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:07:32 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n991DEuU156250
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:13:14 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n991DDER007067
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:13:14 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix direct IO return values over fullfilled fallocate space 

To prepare direct IO write, we need to split the unwritten extents before
submit the IO. In case of no split needs at all, ext4_split_unwritten_extents()
was incorrectly returns 0 instead of the size of uninitialized extents. This bug
caused wrong return value sent back to VFS code when it gets called from async
IO path, leads to falling back to buffered IO.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/extents.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.31-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.31-rc4/fs/ext4/extents.c
@@ -2788,6 +2788,8 @@ fix_extent_len:
  * into three uninitialized extent(at most). After IO complete, the part
  * being filled will be convert to initialized by the end_io callback function
  * via ext4_convert_unwritten_extents().
+ *
+ * Returns the size of uninitialized extent to be written, on success.
  */
 static int ext4_split_unwritten_extents(handle_t *handle,
 					struct inode *inode,
@@ -2805,7 +2807,6 @@ static int ext4_split_unwritten_extents(
 	unsigned int allocated, ee_len, depth;
 	ext4_fsblk_t newblock;
 	int err = 0;
-	int ret = 0;
 
 	ext_debug("ext4_split_unwritten_extents: inode %lu,"
 		  "iblock %llu, max_blocks %u\n", inode->i_ino,
@@ -2827,8 +2828,8 @@ static int ext4_split_unwritten_extents(
  	 * the size of extent to write, there is no need to split
  	 * uninitialized extent
  	 */
- 	if (allocated <= max_blocks)
-		return ret;
+ 	if (iblock == ee_block && allocated <= max_blocks)
+		return allocated;
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)


