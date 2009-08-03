From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH RFC] ext4 direct IO for holes, fallocate
Date: Mon, 03 Aug 2009 16:40:09 -0700
Message-ID: <1249342809.28523.38.camel@mingming-laptop>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
	 <20090729181007.GC14105@mit.edu>
	 <20090730183053.GE9223@atrey.karlin.mff.cuni.cz>
	 <20090730203351.GB6833@mit.edu>
	 <6601abe90907310910n694c32dfob3e2a207b07333f4@mail.gmail.com>
	 <1249109815.15033.17.camel@mingming-laptop>
	 <20090803164705.GA16070@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:59450 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbZHCXkM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 19:40:12 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n73Nafqv018690
	for <linux-ext4@vger.kernel.org>; Mon, 3 Aug 2009 17:36:41 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n73NeCLT222568
	for <linux-ext4@vger.kernel.org>; Mon, 3 Aug 2009 17:40:12 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n73NeB8w024109
	for <linux-ext4@vger.kernel.org>; Mon, 3 Aug 2009 17:40:12 -0600
In-Reply-To: <20090803164705.GA16070@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-08-03 at 22:17 +0530, Aneesh Kumar K.V wrote:
> On Fri, Jul 31, 2009 at 11:56:55PM -0700, Mingming wrote:
> > Hi,
> > 
> > I want to throw out my first attempt to fix the DIO fallocate issue, to
> > see if the approach makes sense. This is the approach I take will
> > 
> > 1) DIO write to hole will not fall back to buffered IO.  holes are
> > marked as unwritten extents after block allocation.
> > 2) New extents allocated at the end of file is also treated as unwritten
> > extents
> > 3) those unwritten extents, and fallocate extents, will be converted to
> > written extents (and update disk isize if needed)when the IO is
> > complete. The conversion is triggered using end_io call back function
> > passing from ext4 fs to direct IO.
> > 
> > 4) We need to tell direct IO do not force create =0 for write on holes.
> > Does not want use blockdev_dio_own_locking(), instead,add another dio
> > type which indicating DIO that fs still needs the lock handling at VFS
> > layer, but wants to take care of the hole/unwritten stuff by fs itself.
> > 
> > untested patch below...
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> >  fs/direct-io.c     |   26 +++++++-
> >  fs/ext4/Makefile   |    4 -
> >  fs/ext4/dio.c      |  162 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/ext4/ext4.h     |   22 ++++++-
> >  fs/ext4/extents.c  |   66 +++++++++++++++++++++
> >  fs/ext4/inode.c    |   83 ---------------------------
> >  fs/ext4/super.c    |   11 +++
> >  include/linux/fs.h |   10 +++
> >  8 files changed, 293 insertions(+), 91 deletions(-)
> > 
> > Index: linux-2.6.31-rc4/fs/ext4/inode.c
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/inode.c	2009-07-31 12:57:53.000000000 -0700
> > +++ linux-2.6.31-rc4/fs/ext4/inode.c	2009-07-31 14:48:27.000000000 -0700
> > @@ -3279,89 +3279,6 @@ static int ext4_releasepage(struct page 
> >  }
> > 
> >  /*
> > - * If the O_DIRECT write will extend the file then add this inode to the
> > - * orphan list.  So recovery will truncate it back to the original size
> > - * if the machine crashes during the write.
> > - *
> > - * If the O_DIRECT write is intantiating holes inside i_size and the machine
> > - * crashes then stale disk data _may_ be exposed inside the file. But current
> > - * VFS code falls back into buffered path in that case so we are safe.
> > - */
> > -static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
> > -			      const struct iovec *iov, loff_t offset,
> > -			      unsigned long nr_segs)
> > -{
> > -	struct file *file = iocb->ki_filp;
> > -	struct inode *inode = file->f_mapping->host;
> > -	struct ext4_inode_info *ei = EXT4_I(inode);
> > -	handle_t *handle;
> > -	ssize_t ret;
> > -	int orphan = 0;
> > -	size_t count = iov_length(iov, nr_segs);
> > -
> > -	if (rw == WRITE) {
> > -		loff_t final_size = offset + count;
> > -
> > -		if (final_size > inode->i_size) {
> > -			/* Credits for sb + inode write */
> > -			handle = ext4_journal_start(inode, 2);
> > -			if (IS_ERR(handle)) {
> > -				ret = PTR_ERR(handle);
> > -				goto out;
> > -			}
> > -			ret = ext4_orphan_add(handle, inode);
> > -			if (ret) {
> > -				ext4_journal_stop(handle);
> > -				goto out;
> > -			}
> > -			orphan = 1;
> > -			ei->i_disksize = inode->i_size;
> > -			ext4_journal_stop(handle);
> > -		}
> > -	}
> > -
> > -	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
> > -				 offset, nr_segs,
> > -				 ext4_get_block, NULL);
> > -
> > -	if (orphan) {
> > -		int err;
> > -
> > -		/* Credits for sb + inode write */
> > -		handle = ext4_journal_start(inode, 2);
> > -		if (IS_ERR(handle)) {
> > -			/* This is really bad luck. We've written the data
> > -			 * but cannot extend i_size. Bail out and pretend
> > -			 * the write failed... */
> > -			ret = PTR_ERR(handle);
> > -			goto out;
> > -		}
> > -		if (inode->i_nlink)
> > -			ext4_orphan_del(handle, inode);
> > -		if (ret > 0) {
> > -			loff_t end = offset + ret;
> > -			if (end > inode->i_size) {
> > -				ei->i_disksize = end;
> > -				block_extend_i_size(inode, offset, ret);
> > -				/*
> > -				 * We're going to return a positive `ret'
> > -				 * here due to non-zero-length I/O, so there's
> > -				 * no way of reporting error returns from
> > -				 * ext4_mark_inode_dirty() to userspace.  So
> > -				 * ignore it.
> > -				 */
> > -				ext4_mark_inode_dirty(handle, inode);
> > -			}
> > -		}
> > -		err = ext4_journal_stop(handle);
> > -		if (ret == 0)
> > -			ret = err;
> > -	}
> > -out:
> > -	return ret;
> > -}
> > -
> > -/*
> >   * Pages can be marked dirty completely asynchronously from ext4's journalling
> >   * activity.  By filemap_sync_pte(), try_to_unmap_one(), etc.  We cannot do
> >   * much here because ->set_page_dirty is called under VFS locks.  The page is
> > Index: linux-2.6.31-rc4/fs/ext4/ext4.h
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/ext4.h	2009-07-31 12:57:53.000000000 -0700
> > +++ linux-2.6.31-rc4/fs/ext4/ext4.h	2009-07-31 23:31:26.000000000 -0700
> > @@ -111,6 +111,15 @@ struct ext4_allocation_request {
> >  	unsigned int flags;
> >  };
> > 
> > +typedef struct ext4_io_end{
> > +	struct inode		*inode;		/* file being written to */
> > +	unsigned int		type;		/* unwritten or written */
> > +	int			error;		/* I/O error code */
> > +	ext4_lblk_t		offset;		/* offset in the file */
> > +	size_t			size;		/* size of the extent */
> > +	struct work_struct	work;		/* data work queue */
> > +}ext4_io_end_t;
> > +
> >  /*
> >   * Special inodes numbers
> >   */
> > @@ -330,8 +339,8 @@ struct ext4_new_group_data {
> >  	/* Call ext4_da_update_reserve_space() after successfully 
> >  	   allocating the blocks */
> >  #define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0008
> > -
> > -
> > +#define EXT4_GET_BLOCKS_DIO			0x0010
> > +#define EXT4_GET_BLOCKS_CONVERT_UNINIT		0x0020
> >  /*
> >   * ioctl commands
> >   */
> > @@ -960,6 +969,9 @@ struct ext4_sb_info {
> > 
> >  	unsigned int s_log_groups_per_flex;
> >  	struct flex_groups *s_flex_groups;
> > +
> > +	/* workqueue for dio unwritten */
> > +	struct workqueue_struct *dio_unwritten_wq;
> >  };
> > 
> >  static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
> > @@ -1453,6 +1465,10 @@ extern __le16 ext4_group_desc_csum(struc
> >  				   struct ext4_group_desc *gdp);
> >  extern int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 group,
> >  				       struct ext4_group_desc *gdp);
> > +/* dio.c */
> > +extern ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
> > +                              const struct iovec *iov, loff_t offset,
> > +                              unsigned long nr_segs);
> > 
> >  static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
> >  {
> > @@ -1650,6 +1666,8 @@ extern void ext4_ext_init(struct super_b
> >  extern void ext4_ext_release(struct super_block *);
> >  extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
> >  			  loff_t len);
> > +extern long ext4_convert_unwritten(struct inode *inode, loff_t offset,
> > +			  loff_t len);
> >  extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
> >  			   sector_t block, unsigned int max_blocks,
> >  			   struct buffer_head *bh, int flags);
> > Index: linux-2.6.31-rc4/fs/ext4/dio.c
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6.31-rc4/fs/ext4/dio.c	2009-07-31 23:24:25.000000000 -0700
> > @@ -0,0 +1,162 @@
> > +/*
> > + *  linux/fs/ext4/dio.c
> > + *
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/jbd2.h>
> > +#include <linux/buffer_head.h>
> > +#include <linux/writeback.h>
> > +#include <linux/bio.h>
> > +#include <linux/workqueue.h>
> > +
> > +#include "ext4_jbd2.h"
> > +
> > +struct workqueue_struct *ext4_unwritten_queue;
> > +
> > +/* Maximum number of blocks we map for direct IO at once. */
> > +#define DIO_MAX_BLOCKS 4096
> > +int ext4_get_block_dio(struct inode *inode, sector_t iblock,
> > +		   struct buffer_head *bh_result, int create)
> > +{
> > +	handle_t *handle;
> > +	int ret = 0, started = 0;
> > +	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> > +	int dio_credits;
> > +	loff_t offset = (loff_t)iblock << inode->i_blkbits;
> > +	unsigned int flags = 0;
> > +
> > +	if (create) {
> > +		if (max_blocks > DIO_MAX_BLOCKS)
> > +			max_blocks = DIO_MAX_BLOCKS;
> > +		dio_credits = ext4_chunk_trans_blocks(inode, max_blocks);
> > +		handle = ext4_journal_start(inode, dio_credits);
> > +		if (IS_ERR(handle)) {
> > +			ret = PTR_ERR(handle);
> > +			goto out;
> > +		}
> > +		started = 1;
> > +
> > +		flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
> 
> That would imply we are always creating uninit extent. You will have to make
> sure we do the right thing with bh_flag of bh_result in this case. We have
> ignored bh_flag update for EXT4_GET_BLOCKS_CREATE_UNINIT_EXT because that was
> initially done only from the fallocate call path which didn't look at the flag
> at all.
> 

I have checked the return from ext4_ext_get_blocks(), with the
EXT4_GET_BLOCKS_CREATE_UNINIT_EXT flag, on success of block fallocate
for holes/extend file size, the buffer is always marked mapped. If we do
a EXT4_GET_BLOCKS_CREATE_UNINIT_EXT on an already-fallocated-extent,
then the bh is marked as mapped too. They all go out to the "out" 
at the end.
> 
> 
> > +	}
> > +
> > +	ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
> > +			      flags);
> > +	if (ret > 0) {
> > +		bh_result->b_size = (ret << inode->i_blkbits);
> > +		ret = 0;
> > +	}
> > +	if (started)
> > +		ext4_journal_stop(handle);
> > +out:
> > +	return ret;
> > +}
> > +
> > +#define		DIO_UNWRITTEN	0x1
> > +
> > +/*
> > + * IO write completion for unwritten extents.
> > + *
> > + * convert a buffer range from unwritten to written extents.
> > + */
> > +static void ext4_end_dio_unwritten(struct work_struct *work)
> > +{
> > +	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
> > +	struct inode *inode = io->inode;
> > +	loff_t offset = io->offset;
> > +	size_t size = io->size;
> > +	
> > +	ext4_convert_unwritten(inode, offset, size);
> > +
> > +	kfree(io);
> > +}
> > +
> > +ext4_io_end_t *ext4_init_io_end (struct inode *inode, unsigned int type)
> > +{
> > +	ext4_io_end_t *io = NULL;
> > +
> > +	io = kmalloc(sizeof(*io), GFP_NOFS);
> > +
> > +	if (io) {
> > +		io->inode = inode;
> > +		io->type = type;
> > +		io->offset = 0;
> > +		io->size = 0;
> > +		io->error = 0;
> > +		INIT_WORK(&io->work, ext4_end_dio_unwritten);
> > +	}
> > +
> > +	return io;
> > +}
> > +
> > +static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> > +			    ssize_t size, void *private)
> > +{
> > +        ext4_io_end_t *io_end = iocb->private;
> > +	struct workqueue_struct *wq;
> > +	/*FIX ME  call ext4 code to convert the extents, commit the log*/
> > +
> > +	/* if not hole or unwritten extents, just simple return */
> > +	if (!io_endi || !size)
> > +		return;
> > +	io_end->offset = offset;
> > +	io_end->size = size;
> > +	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> > +
> > +	/* We need to convert unwritten extents to written */
> > +	queue_work(wq, &io_end->work);
> > +
> > +        if (is_sync_kiocb(iocb))
> > +		flush_workqueue(wq);
> > +
> > +	iocb->private = NULL;
> > +}
> > +/*
> > + * If the O_DIRECT write will extend the file then add this inode to the
> > + * orphan list.  So recovery will truncate it back to the original size
> > + * if the machine crashes during the write.
> > + *
> > + * If the O_DIRECT write is filling unintialized space inside i_size,
> > + * convertion to initialized extent should happen after data written to disk
> > + * to ensure we don't expose stale disk data after crash.
> > + */
> > +ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
> > +			      const struct iovec *iov, loff_t offset,
> > +			      unsigned long nr_segs)
> > +{
> > +	struct file *file = iocb->ki_filp;
> > +	struct inode *inode = file->f_mapping->host;
> > +	struct ext4_inode_info *ei = EXT4_I(inode);
> > +	handle_t *handle;
> > +	ssize_t ret;
> > +	int orphan = 0;
> > +	size_t count = iov_length(iov, nr_segs);
> > +
> > +	if (rw == WRITE) {
> > +		/*
> > + 		 * we treat blocks allocated for DIO as
> > + 		 * as unwritten extents, need to convert them
> > + 		 * to written extents when IO is complete.
> > + 		 *
> > + 		 * In the case of AIO DIO, since VFS dio code
> > + 		 * does not wait for io complete, here 
> > + 		 * i_size update needs to be buddled at the
> > + 		 * time DIO IO is completed, not here
> > + 		 */
> > +		iocb->private = ext4_init_io_end(inode, DIO_UNWRITTEN);
> > +		if (!iocb->private)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	ret = blockdev_direct_IO_hole(rw, iocb, inode,
> > +				 inode->i_sb->s_bdev, iov,
> > +				 offset, nr_segs,
> > +				 ext4_get_block_dio, ext4_end_io_dio);
> > +
> > + 	/* In the case of AIO DIO, VFS dio,
> > + 	 * does not wait for io complete, here 
> > + 	 * i_size update needs to be buddled at the
> > + 	 * time DIO IO is completed, not here
> > + 	 */
> > +	return ret;
> > +}
> > Index: linux-2.6.31-rc4/fs/ext4/Makefile
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/Makefile	2009-07-31 14:51:38.000000000 -0700
> > +++ linux-2.6.31-rc4/fs/ext4/Makefile	2009-07-31 15:07:54.000000000 -0700
> > @@ -6,8 +6,8 @@ obj-$(CONFIG_EXT4_FS) += ext4.o
> > 
> >  ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
> >  		ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
> > -		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o
> > -
> > +		ext4_jbd2.o migrate.o mballoc.o block_validity.o \
> > +		move_extent.o dio.o
> >  ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
> >  ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
> >  ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
> > Index: linux-2.6.31-rc4/fs/ext4/super.c
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/super.c	2009-07-31 15:26:23.000000000 -0700
> > +++ linux-2.6.31-rc4/fs/ext4/super.c	2009-07-31 15:57:52.000000000 -0700
> > @@ -578,6 +578,9 @@ static void ext4_put_super(struct super_
> >  	struct ext4_super_block *es = sbi->s_es;
> >  	int i, err;
> > 
> > +	flush_workqueue(sbi->dio_unwritten_wq);
> > +	destroy_workqueue(sbi->dio_unwritten_wq);
> > +
> >  	lock_super(sb);
> >  	lock_kernel();
> >  	if (sb->s_dirt)
> > @@ -2781,6 +2784,12 @@ no_journal:
> >  			clear_opt(sbi->s_mount_opt, NOBH);
> >  		}
> >  	}
> > +	EXT4_SB(sb)->dio_unwritten_wq = create_workqueue("ext4-dio-unwritten");
> > +	if (!EXT4_SB(sb)->dio_unwritten_wq) {
> > +		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
> > +		goto failed_mount_wq;
> > +	}
> > +
> >  	/*
> >  	 * The jbd2_journal_load will have done any necessary log recovery,
> >  	 * so we can safely mount the rest of the filesystem now.
> > @@ -2893,6 +2902,8 @@ cantfind_ext4:
> > 
> >  failed_mount4:
> >  	ext4_msg(sb, KERN_ERR, "mount failed");
> > +	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
> > +failed_mount_wq:
> >  	ext4_release_system_zone(sb);
> >  	if (sbi->s_journal) {
> >  		jbd2_journal_destroy(sbi->s_journal);
> > Index: linux-2.6.31-rc4/fs/direct-io.c
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/direct-io.c	2009-07-31 17:12:30.000000000 -0700
> > +++ linux-2.6.31-rc4/fs/direct-io.c	2009-07-31 17:25:17.000000000 -0700
> > @@ -240,7 +240,7 @@ static int dio_complete(struct dio *dio,
> >  	if (dio->end_io && dio->result)
> >  		dio->end_io(dio->iocb, offset, transferred,
> >  			    dio->map_bh.b_private);
> > -	if (dio->lock_type == DIO_LOCKING)
> > +	if (dio->lock_type == DIO_LOCKING || dio->lock_type == DIO_LOCKING_HOLE)
> >  		/* lockdep: non-owner release */
> >  		up_read_non_owner(&dio->inode->i_alloc_sem);
> > 
> > @@ -516,6 +516,17 @@ static int get_more_blocks(struct dio *d
> >  		map_bh->b_size = fs_count << dio->inode->i_blkbits;
> > 
> >  		create = dio->rw & WRITE;
> > +		/*
> > +		 * If the dio lock type does not indicate the underlying
> > +		 * fs could handle unwritten extents, pass create as 0 to
> > +		 * just do a plain block look up. If it is a hole, DIO will
> > +		 * falls back to buffered IO to prevent stale data out after
> > +		 * crash before IO complete.
> > +		 * 
> > +		 * if the dio lock type is DIO_LOCKING_HOLE
> > +		 * then dio will preserve the create flag, and let the
> > +		 * underlying filesystem to handle the hole issue. 
> > +		 */
> >  		if (dio->lock_type == DIO_LOCKING) {
> >  			if (dio->block_in_file < (i_size_read(dio->inode) >>
> >  							dio->blkbits))
> > @@ -1042,7 +1053,8 @@ direct_io_worker(int rw, struct kiocb *i
> >  	 * we can let i_mutex go now that its achieved its purpose
> >  	 * of protecting us from looking up uninitialized blocks.
> >  	 */
> > -	if ((rw == READ) && (dio->lock_type == DIO_LOCKING))
> > +	if ((rw == READ) && (dio->lock_type == DIO_LOCKING ||
> > +			dio->lock_type == DIO_LOCKING_HOLE))
> >  		mutex_unlock(&dio->inode->i_mutex);
> > 
> >  	/*
> > @@ -1097,6 +1109,10 @@ direct_io_worker(int rw, struct kiocb *i
> >   * For reads, i_mutex is not held on entry, but it is taken and dropped before
> >   * returning.
> >   *
> > + * DIO_LOCKING_HOLE (simple locking for regular files)
> > + * Same as above, except that filesystem support unwritten extents thus
> > + * allow DIO to write to holes, no need to fall back to buffered IO.
> > + *
> >   * DIO_OWN_LOCKING (filesystem provides synchronisation and handling of
> >   *	uninitialised data, allowing parallel direct readers and writers)
> >   * For writes we are called without i_mutex, return without it, never touch it.
> > @@ -1190,7 +1206,8 @@ __blockdev_direct_IO(int rw, struct kioc
> >  			}
> >  		}
> > 
> > -		if (dio_lock_type == DIO_LOCKING)
> > +		if (dio_lock_type == DIO_LOCKING ||
> > +			dio_lock_type == DIO_LOCKING_HOLE)
> >  			/* lockdep: not the owner will release it */
> >  			down_read_non_owner(&inode->i_alloc_sem);
> >  	}
> > @@ -1220,7 +1237,8 @@ __blockdev_direct_IO(int rw, struct kioc
> >  			vmtruncate(inode, isize);
> >  	}
> > 
> > -	if (rw == READ && dio_lock_type == DIO_LOCKING)
> > +	if (rw == READ && (dio_lock_type == DIO_LOCKING ||
> > +			dio_lock_type == DIO_LOCKING_HOLE))
> >  		release_i_mutex = 0;
> > 
> >  out:
> > Index: linux-2.6.31-rc4/include/linux/fs.h
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/include/linux/fs.h	2009-07-31 17:09:07.000000000 -0700
> > +++ linux-2.6.31-rc4/include/linux/fs.h	2009-07-31 17:20:39.000000000 -0700
> > @@ -2255,6 +2255,7 @@ enum {
> >  	DIO_LOCKING = 1, /* need locking between buffered and direct access */
> >  	DIO_NO_LOCKING,  /* bdev; no locking at all between buffered/direct */
> >  	DIO_OWN_LOCKING, /* filesystem locks buffered and direct internally */
> > +	DIO_LOCKING_HOLE /* need locking, but allow DIO write to holes */
> >  };
> > 
> >  static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
> > @@ -2283,6 +2284,15 @@ static inline ssize_t blockdev_direct_IO
> >  	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
> >  				nr_segs, get_block, end_io, DIO_OWN_LOCKING);
> >  }
> > +
> > +static inline ssize_t blockdev_direct_IO_hole(int rw, struct kiocb *iocb,
> > +	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
> > +	loff_t offset, unsigned long nr_segs, get_block_t get_block,
> > +	dio_iodone_t end_io)
> > +{
> > +	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
> > +				nr_segs, get_block, end_io, DIO_LOCKING_HOLE);
> > +}
> >  #endif
> > 
> >  extern const struct file_operations generic_ro_fops;
> > Index: linux-2.6.31-rc4/fs/ext4/extents.c
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/extents.c	2009-07-31 22:45:58.000000000 -0700
> > +++ linux-2.6.31-rc4/fs/ext4/extents.c	2009-07-31 23:37:20.000000000 -0700
> > @@ -3170,6 +3170,72 @@ retry:
> >  	return ret > 0 ? ret2 : ret;
> >  }
> > 
> > +long ext4_convert_unwritten(struct inode *inode, loff_t offset, loff_t len)
> > +{
> > +	handle_t *handle;
> > +	ext4_lblk_t block;
> > +	loff_t new_size;
> > +	unsigned int max_blocks;
> > +	int ret = 0;
> > +	int ret2 = 0;
> > +	struct buffer_head map_bh;
> > +	unsigned int credits, blkbits = inode->i_blkbits;
> > +
> > +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > +		return -EOPNOTSUPP;
> > +
> > +	block = offset >> blkbits;
> > +	/*
> > +	 * We can't just convert len to max_blocks because
> > +	 * If blocksize = 4096 offset = 3072 and len = 2048
> > +	 */
> > +	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> > +							- block;
> > +	/*
> > +	 * credits to insert 1 extent into extent tree
> > +	 */
> > +	credits = ext4_chunk_trans_blocks(inode, max_blocks);
> > +	while (ret >= 0 && ret < max_blocks) {
> > +		block = block + ret;
> > +		max_blocks = max_blocks - ret;
> > +		handle = ext4_journal_start(inode, credits);
> > +		if (IS_ERR(handle)) {
> > +			ret = PTR_ERR(handle);
> > +			break;
> > +		}
> > +		map_bh.b_state = 0;
> > +		ret = ext4_get_blocks(handle, inode, block,
> > +				      max_blocks, &map_bh,
> > +				      EXT4_GET_BLOCKS_CONVERT_UNINIT_EXT)
> 
> Where is EXT4_GET_BLOCKS_CONVERT_UNINIT_EXT defined ? Assuming it is 
> EXT4_GET_BLOCKS_CREATE, it implies we can endup doing block allocation
> here. If we don't have enough space, we zero-out the full extent. Which
> implies we would endup overwritting the already wrote contents.
> 

Sorry the patch was not the latest one. The
EXT4_GET_BLOCKS_CONVERT_UNINIT_EXT flag is set different than
EXT4_GET_BLOCKS_CREATE. It there to notify that we should not do block
allocation, and avoid zero out the full extent. I was planning to add
another code to zero out only the uninitialized part of the extents.

> ;
> > +		if (ret <= 0) {
> > +			WARN_ON(ret <= 0);
> > +			printk(KERN_ERR "%s: ext4_ext_get_blocks "
> > +				    "returned error inode#%lu, block=%u, "
> > +				    "max_blocks=%u", __func__,
> > +				    inode->i_ino, block, max_blocks);
> > +			ext4_mark_inode_dirty(handle, inode);
> > +			ret2 = ext4_journal_stop(handle);
> > +			break;
> > +		}
> > +
> > +		if ((block + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
> > +						blkbits) >> blkbits))
> > +			new_size = offset + len;
> > +		else
> > +			new_size = (block + ret) << blkbits;
> > +
> > +		if (new_size > i_size_read(inode))
> > +			i_size_write(inode, new_size);
> 
> shouldn't i_size update always happen with inode->i_mutex held. I guess
> we can't do a i_size update in end_io call back.
> 
> 
Maybe you are right, i_size update should already been taken care of at
the ext4_direct_IO() code, I will correct this.

> > +		if (new_size > EXT4_I(inode)->i_disksize) 
> > +			ext4_update_i_disksize(inode, new_size);
> > +
> > +		ext4_mark_inode_dirty(handle, inode);
> > +		ret2 = ext4_journal_stop(handle);
> > +		if (ret2)
> > +			break;
> > +	}
> > +	return ret > 0 ? ret2 : ret;
> > +}
> >  /*
> >   * Callback function called for each extent to gather FIEMAP information.
> >   */
> > 
> > 
> 
> 
> Can you send it as a multi patch series. Having only ext4 specific changes
> to look at will makes this review easier.
> 

Yes I am planning to. 

About the DIO layer change, all we need is a way to pass create=1 for
holes/fallocate from DIO. If there is a clear way to do from DIO that
would be greate. Otherwise, I was actually thinking we could workaround
in ext4, which we create a seperate ext4 directio get_block() function
for write and read. So when ext4_get_block_dio_write() is called, it
could override the create flag passed from DIO, and do the mapping for
fallocate and hole. Again,the best solution is to fix DIO code to pass
the flag to allow hole/fallocate map/filling,for fs like ext4 who wants
to do so.

Mingming


