From: Mingming <cmm@us.ibm.com>
Subject: [PATCH 2/4 v2] avoid perform unwritten convertion for direct IO
 over non fallocated space
Date: Thu, 08 Oct 2009 18:13:30 -0700
Message-ID: <1255050810.4931.191.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:56260 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbZJIBOL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2009 21:14:11 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n99177PV031514
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:07:07 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n991DW8X245432
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:13:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n991DV7Q007678
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 19:13:32 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: avoid perform unwritten convertion for direct IO over non fallocated space

When direct IO complete, without this patch, it always check and convert
the range covered by the completed IO to be written. This is unnecessary
if the range doesn't has any preallocated area or holes. This patch add
a state flag to alart direct IO code to only run the convertion when
there is unwritten extents being covered in this IO.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   22 +++++++++++++++++-----
 fs/ext4/inode.c   |    4 +++-
 3 files changed, 21 insertions(+), 6 deletions(-)

Index: linux-2.6.31-rc4/fs/ext4/ext4.h
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/ext4.h
+++ linux-2.6.31-rc4/fs/ext4/ext4.h
@@ -299,6 +299,7 @@ static inline __u32 ext4_mask_flags(umod
 #define EXT4_STATE_XATTR		0x00000004 /* has in-inode xattrs */
 #define EXT4_STATE_NO_EXPAND		0x00000008 /* No space for expansion */
 #define EXT4_STATE_DA_ALLOC_CLOSE	0x00000010 /* Alloc DA blks on close */
+#define EXT4_STATE_DIO_UNWRITTEN	0x00000020 /* need convert on dio done*/
 
 /* Used to pass group descriptor data when online resize is done */
 struct ext4_new_group_input {
Index: linux-2.6.31-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.31-rc4/fs/ext4/extents.c
@@ -3029,12 +3029,18 @@ ext4_ext_handle_uninitialized_extents(ha
 		ret = ext4_split_unwritten_extents(handle,
 						inode, path, iblock,
 						max_blocks, flags);
-		/* flag the io_end struct that we need convert when IO done */
+		/*
+		 * Flag the inode(non aio case) or end_io struct (aio case)
+		 * that this IO needs to convertion to written when IO is
+		 * completed
+		 */
 		if (io)
 			io->flag = DIO_AIO_UNWRITTEN;
+		else
+			EXT4_I(inode)->i_state |= EXT4_STATE_DIO_UNWRITTEN;
 		goto out;
 	}
-	/* DIO end_io complete, convert the filled extent to written */
+	/* async DIO end_io complete, convert the filled extent to written */
 	if (flags == EXT4_GET_BLOCKS_DIO_CONVERT_EXT) {
 		ret = ext4_convert_unwritten_extents_dio(handle, inode,
 							path);
@@ -3276,10 +3282,16 @@ int ext4_ext_get_blocks(handle_t *handle
 		 * To avoid unecessary convertion for every aio dio rewrite
 		 * to the mid of file, here we flag the IO that is really
 		 * need the convertion.
-		 *
+		 * For non asycn direct IO case, flag the inode state
+		 * that we need to perform convertion when IO is done.
 		 */
-		if (io && flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT)
-			io->flag = DIO_AIO_UNWRITTEN;
+		if (flags == EXT4_GET_BLOCKS_DIO_CREATE_EXT) {
+			if (io)
+				io->flag = DIO_AIO_UNWRITTEN;
+			else
+				EXT4_I(inode)->i_state |=
+					EXT4_STATE_DIO_UNWRITTEN;;
+		}
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
Index: linux-2.6.31-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/inode.c
+++ linux-2.6.31-rc4/fs/ext4/inode.c
@@ -3693,7 +3693,8 @@ static ssize_t ext4_ext_direct_IO(int rw
 		if (ret != -EIOCBQUEUED && ret <= 0 && iocb->private) {
 			ext4_free_io_end(iocb->private);
 			iocb->private = NULL;
-		} else if (ret > 0){
+		} else if (ret > 0 && EXT4_I(inode)->i_state &
+				EXT4_STATE_DIO_UNWRITTEN){
 			int err;
 			/*
 			 * for non AIO case, since the IO is already
@@ -3703,6 +3704,7 @@ static ssize_t ext4_ext_direct_IO(int rw
 								offset, ret);
 			if (err < 0)
 				ret = err;
+			EXT4_I(inode)->i_state &= ~EXT4_STATE_DIO_UNWRITTEN;
 		}
 		return ret;
 	}


