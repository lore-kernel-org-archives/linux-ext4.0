From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 2/2]Fix return value of splitting extents for dio write
 over fallocate
Date: Wed, 07 Oct 2009 11:50:29 -0700
Message-ID: <1254941429.18662.8.camel@mingming-laptop>
References: <1254936214.18662.7.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:34619 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZJGSvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Oct 2009 14:51:25 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e31.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n97IiMuc024445
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 12:44:22 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n97IoVu0163150
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 12:50:40 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n97IoU1f019421
	for <linux-ext4@vger.kernel.org>; Wed, 7 Oct 2009 12:50:30 -0600
In-Reply-To: <1254936214.18662.7.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-10-07 at 10:23 -0700, Mingming wrote:
> ext4: Fix return value of splitting extents for dio write over fallocate 

Please pick up this patch instead, after fixing compile warning.

ext4: Fix return value of splitting extents for dio write over fallocate

To prepare direct IO write, we need to split the unwritten extents before
submit the IO. In case of no split needs at all, ext4_split_unwritten_extents()
was incorrectly returns 0 instead of the size of uninitalized extents. This bug
caused wrong return value sent back to VFS code when it gets called from async
IO path, leads to falling back to buffered IO.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/extents.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
@@ -2805,7 +2807,6 @@ static int ext4_split_unwritten_extents(
 	unsigned int allocated, ee_len, depth;
 	ext4_fsblk_t newblock;
 	int err = 0;
-	int ret = 0;
 	unsigned int newdepth;
 
 	ext_debug("ext4_split_unwritten_extents: inode %lu,"
@@ -2829,7 +2830,7 @@ static int ext4_split_unwritten_extents(
  	 * uninitialized extent
  	 */
  	if (allocated <= max_blocks)
-		return ret;
+		return allocated;
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)


