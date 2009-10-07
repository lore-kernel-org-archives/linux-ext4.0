From: Mingming <cmm@us.ibm.com>
Subject: [PATCH 2/2]Fix return value of splitting extents for dio write
 over fallocate
Date: Wed, 07 Oct 2009 10:23:34 -0700
Message-ID: <1254936214.18662.7.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:36609 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZJGRYS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Oct 2009 13:24:18 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n97HLct8022474
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 11:21:38 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n97HNaVL153214
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 11:23:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n97HNaEu018833
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 11:23:36 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix return value of splitting extents for dio write over fallocate 

To prepare direct IO write, we need to split the unwritten extents before
submit the IO. In case of there is no need to split at all, ext4_split_unwritten_extents()
was incorrectly returns 0 instead of the size of uninitalized extents. This bug
caused the buffer remains unmapped, thus mislead VFS direct IO falling back to buffered IO.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/extents.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.31-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.31-rc4/fs/ext4/extents.c
@@ -2788,6 +2788,8 @@ fix_extent_len:
  * into three uninitialized extent(at most). After IO complete, the part
  * being filled will be convert to initialized by the end_io callback function
  * via ext4_convert_unwritten_extents().
+ *
+ * Returns the size of unitialized extent to be writen, on success.
  */
 static int ext4_split_unwritten_extents(handle_t *handle,
 					struct inode *inode,
@@ -2829,7 +2831,7 @@ static int ext4_split_unwritten_extents(
  	 * uninitialized extent
  	 */
  	if (allocated <= max_blocks)
-		return ret;
+		return allocated;
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)


