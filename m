From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: When reading from fallocated blocks make sure we
	return zero.
Date: Mon, 18 Feb 2008 16:14:34 -0800
Message-ID: <1203380074.3629.35.camel@localhost.localdomain>
References: <1203099414-8815-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1203104584.3598.4.camel@localhost.localdomain>
	 <20080216032334.GA6501@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56363 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbYBSAOl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 19:14:41 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J0Eboj032640
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 19:14:37 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J0EbPt254870
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 19:14:37 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J0EbFw026958
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 19:14:37 -0500
In-Reply-To: <20080216032334.GA6501@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-02-16 at 08:53 +0530, Aneesh Kumar K.V wrote:
> On Fri, Feb 15, 2008 at 11:43:04AM -0800, Mingming Cao wrote:
> > On Fri, 2008-02-15 at 23:46 +0530, Aneesh Kumar K.V wrote:
> > > fallocate blocks are considered as sparse area and read from them should
> > > return zero. ext4_ext_get_blocks should return zero for read request.
> > > 
> > 
> > The patch itself looks harmless, but I still don't see how this could
> > fix the problem you described at irc: a write hit a BUG_ON() in
> > fs/buffer.c saying the buffer is not mapped. Could you add more details
> > here?
> 
> Write will take the below call chain
> 
> ext4_write_begin
>   block_write_begin
>     __block_prepare_write
>        ext4_getblock
>          ext4_get_blocks_wrap
> (1)	   ext4_ext_get_blocks with create = 0 return allocated
>        ll_rw_block  if buffer not uptodate.
>          submit_bh
> 	   BUG_ON(!buffer_mapped(bh))
> 
> 
> ext4_ext_get_blocks at (1) should have returned 0. That would cause
> ext4_get_blocks_wrap to again call ext4_ext_get_blocks with create = 1
> and that would have returned us the buffer head which is mapped. This
> would also result in splitting the extent to initialized and
> uninitialized one.
> 

I see what is happening. Your fix seems treated preallocated blocks as
holes equally when get_blocks() with create = 0. This works for the
current case, but now I think the patch has side effect to delayed
allocation.  

How about the following patch?

Regards,
Mingming

ext4: ext4_get_blocks_wrap fix for writing to preallocated
From: Mingming Cao <cmm@us.ibm.com>

This patch fixed a issue with wrting to a preallocated blocks.
A write hit a BUG_ON() in fs/buffer.c saying the buffer is not mapped.

On the write path, ext4_get_block_wrap() is called with create=1, but it
will pass create=0 down to the underlying ext4ext_get_blocks()
to do a look up first.  In the preallocation case, ext4_ext_get_blocks()
with create = 0, will return number of blocks pre-allocated and buffer
head unmapped. ext4_get_blocks_wrap() thinks it succeeds too early, without
checking if it needs again call ext4_ext_get_blocks with create = 1
which would do proper handling for writing to preallocated blocks:
split the extent to initialized and uninitialized one and
returns the mapped buffer head.

Treating preallocated blocks as holes equally(i.e. ignoring the number of blocks
pre-allocated and returns 0) when get_blocks() is called with create = 0 is not enough.
ext4_ext_get_blocks() needs to differentiate these two cases for delayed allocation
purpose, as for holes it need to do reservation and prepare for later
delayed allocation, but for pre-allocated blocks it needs skip that work.

It would makes things more clear if we have clear definition of what
get_blocks() return value means.

Similar to ext4_get_blocks_handle(),  the following 
* return > 0, # of blocks already allocated
*          if these are pre-allocated blocks and create = 0
*             buffer head is unmapped
*          otherwise blocks are mapped.
*
* return = 0, if plain look up failed (blocks have not been allocated)
*          buffer head is unmapped
*
* return < 0, error case.

The for the write path, at ext4_ext_get_blocks_wrap(), it could check the
buffer_mapped() status for preallocated extent before quit too early.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/extents.c |   13 +++++++++++++
 fs/ext4/inode.c   |   41 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

Index: linux-2.6.25-rc2/fs/ext4/extents.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/extents.c	2008-02-18 15:39:52.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/extents.c	2008-02-18 15:43:33.000000000 -0800
@@ -2285,9 +2285,22 @@ out:
 }
 
 /*
+ * Block allocation/map/preallocation routine for extents based files
+ *
+ *
  * Need to be called with
  * down_read(&EXT4_I(inode)->i_data_sem) if not allocating file system block
  * (ie, create is zero). Otherwise down_write(&EXT4_I(inode)->i_data_sem)
+ *
+ * return > 0, number of of blocks already mapped/allocated
+ *          if these are pre-allocated blocks, buffer head is unmapped if
+ *          create = 0 (look up only)
+ *          otherwise blocks are mapped
+ *
+ * return = 0, if plain look up failed (blocks have not been allocated)
+ *          buffer head is unmapped
+ *
+ * return < 0, error case.
  */
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
Index: linux-2.6.25-rc2/fs/ext4/inode.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/inode.c	2008-02-18 15:07:00.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/inode.c	2008-02-18 15:43:59.000000000 -0800
@@ -908,6 +908,26 @@ out:
  */
 #define DIO_CREDITS 25
 
+
+/*
+ * ext4 get_block() wrapper function
+ * It first do a look up, returns if the blocks already mapped. Otherwise
+ * it takes the write sem and do block allocation
+ *
+ * If file type is extents based, call with ext4_ext_get_blocks()
+ * Otherwise, call with ext4_get_blocks_handle() to handle indirect mapping
+ * based files
+ *
+ * return > 0, number of of blocks already mapped/allocated
+ *          if these are pre-allocated blocks, buffer head is unmapped if
+ *          create = 0 (look up only)
+ *          otherwise blocks are mapped
+ *
+ * return = 0, if plain look up failed (blocks have not been allocated)
+ *          buffer head is unmapped
+ *
+ * return < 0, error case.
+ */
 int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned long max_blocks, struct buffer_head *bh,
 			int create, int extend_disksize)
@@ -926,12 +946,27 @@ int ext4_get_blocks_wrap(handle_t *handl
 				inode, block, max_blocks, bh, 0, 0);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
-	if (!create || (retval > 0))
+
+	/* If it is only a block(s) look up */
+	if (!create )
+		return retval;
+
+	/*
+	 * Returns if the blocks have already allocated
+	 *
+	 * Note that if blocks have been preallocated
+	 * ext4_ext_get_block() returns with buffer head unmapped.
+	 * Write to a preallocated space needs to split
+	 * the preallocated extents, thus needs to update
+	 * i_data
+	 */
+	if (retval > 0 && buffer_mapped(bh))
 		return retval;
 
 	/*
-	 * We need to allocate new blocks which will result
-	 * in i_data update
+	 * New blocks and preallocation handling will possiblely result
+	 * in i_data update, take the write sem, and call get_blocks()
+	 * with create = 1
 	 */
 	down_write((&EXT4_I(inode)->i_data_sem));
 	/*
