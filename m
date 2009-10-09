From: Mingming <cmm@us.ibm.com>
Subject: [PATCH 1/4 v2] Direct IO return value fix for holes/fallocate
Date: Thu, 08 Oct 2009 18:13:16 -0700
Message-ID: <1255050796.4931.190.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:45570 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbZJIBOD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2009 21:14:03 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9912kSS029967
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:02:46 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n991DMvM169622
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:13:22 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n991DHr3007162
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:13:21 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Direct IO return value fix for holes/fallocate

When direct IO complete, ext4 will convert unwritten extents to written,
for
writes over preallocated space, or holes.

ext4_direct_IO should returns the number of bytes read/write on success.
However there is a bug that cause ext4_direct_IO returns the number of
bytes converted to written extents, which is 0 on success. This bug
causes
direct IO falls back to buffered IO even on sucessful rewrites or
preallocated space. 

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.31-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.31-rc4/fs/ext4/extents.c
@@ -3500,6 +3500,7 @@ retry:
  *
  * This function is called from the direct IO end io call back
  * function, to convert the fallocated extents after IO is completed.
+ * Returns 0 on success.
  */
 int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 				    loff_t len)
Index: linux-2.6.31-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/inode.c
+++ linux-2.6.31-rc4/fs/ext4/inode.c
@@ -3693,13 +3693,17 @@ static ssize_t ext4_ext_direct_IO(int rw
 		if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
 			ext4_free_io_end(iocb->private);
 			iocb->private = NULL;
-		} else if (ret > 0)
+		} else if (ret > 0){
+			int err;
 			/*
 			 * for non AIO case, since the IO is already
 			 * completed, we could do the convertion right here
 			 */
-			ret = ext4_convert_unwritten_extents(inode,
+			err = ext4_convert_unwritten_extents(inode,
 								offset, ret);
+			if (err < 0)
+				ret = err;
+		}
 		return ret;
 	}
 


