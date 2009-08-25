From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 1/2 V2] Direct IO for holes and fallocate: add end_io
 callback
Date: Tue, 25 Aug 2009 12:41:10 -0700
Message-ID: <1251229270.3930.17.camel@mingming-laptop>
References: <1250092470.18329.27.camel@mingming-laptop>
	 <20090819141557.GA4705@atrey.karlin.mff.cuni.cz>
	 <1250717176.3924.116.camel@mingming-laptop>
	 <20090820115212.GA16486@duck.novell.com>
	 <1251149893.4280.69.camel@mingming-laptop>
	 <20090825140113.GG405@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:54914 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbZHYTlg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 15:41:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7PJbZxK002765
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 13:37:35 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7PJfI9x152764
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 13:41:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7PJfGi2013370
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 13:41:17 -0600
In-Reply-To: <20090825140113.GG405@duck.novell.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-08-25 at 16:01 +0200, Jan Kara wrote:
> On Mon 24-08-09 14:38:13, Mingming wrote:
> > On Thu, 2009-08-20 at 13:52 +0200, Jan Kara wrote:
> > > On Wed 19-08-09 14:26:16, Mingming wrote:
> > > > On Wed, 2009-08-19 at 16:15 +0200, Jan Kara wrote:
> > > > > > For direct IO write to the end of file, we now also could get rid of
> > > > > > using orphan list to protect expose stale data out after crash, when
> > > > > > direct write to end of file isn't complete. We now fallocate blocks for
> > > > > > the direct IO write to the end of file as well, and convert those
> > > > > > fallocated blocks at the end of file to written when IO is complete. If
> > > > > > fs crashed before the IO complete, it will only seen the file tail has
> > > > > > been fallocated but won't get the stale data out.
> > > > >   But you still probably need orphan list to truncate blocks allocated
> > > > > beyond file end during extending direct write. So I'd just remove this
> > > > > paragraph...
> > > > > 
> > > > 
> > > > Do we still need to truncate blocks allocated at the end of file? Those
> > > > blocks are marked as uninitialized extents (as any block allocation from
> > > > DIO are flagged as uninitialized extents, before IO is complete), so
> > > > that after recover from crash, the stale data won't get exposed. 
> > > > 
> > > > I guess I missed the cases you concerned that we need the orphan list to
> > > > protect, could you plain a little more?
> > >   Well, you are right it's not a security problem since no data gets
> > > exposed. It's just that after a crash, there will be blocks allocated to
> > > a file and it's not trivial to it find out unless you specifically stat the
> > > file. So it's just *not nice* kind of thing. If it brings us some
> > > advantage to not put the inode on the orphan list, then sure it might be
> > > a tradeoff we are willing to make. But otherwise I see no point.
> > > 
> > 
> > Hmm... I see what you concerned now...user probably don't like allocated
> > blocks at the end...
>   Yes, it's kind of counterintuitive that blocks can get allocated but
> don't really "show up" in the file (because they are unwritten and beyond
> i_size).
> 
> > I am trying to think of the ext3 case. In ext3 case, inode will be
> > removed from orphan list once the IO is complete, but that is before the
> > i_disksize get updated and journal handle being closed. What if the
> > system crash after inode removed from orphan list but before the
> > i_disksize get updated?
>   As you write below, until we stop the handle, the transaction cannot be
> committed and so no change actually gets written to disk.
> 

Then in case this, if no change actually gets written to disk, then
i_disksize hasn't get updated on disk, why we need the orphan list?

> > But since the journal handled has not marked as stopped, even without
> > putting the inode on the orpah list, wouldn't the open journal handle
> > and delayed i_disksize update until IO complete time, prevent we see
> > half DIO data on disk? Though blocks are allocated to the file, but
> > those block mapping wouldn't show up on disk, no? Did I miss anything?
> > 
> > In the ext4 +patch case (non AIO case), we also close the handle when
> > end_io completed. If the system crashed we would see the blocks are
> > allocated but marked as unwritten.
>   Exactly, you end up with allocated and unwritten blocks beyond i_size and
> that's what I'd like to avoid if user did not explicitely fallocate() these
> blocks.
> 

Yes but same as ext3, nothing should write to disk until we stop the
handle, so the unwritten blocks flag should also been seen as the
i_disksize has not been updated on disk yet.

> > > > > > 1) Block allocation needed for DIO write are fallocated, including holes
> > > > > > and file tail write, marked as unwritten extents after block allocation.
> > > > > > 
> > > > > > 2) those unwritten extents, and fallocate extents, will be converted to
> > > > > > written extents (and update disk size when write to end of file)when the
> > > > > > IO is complete. The conversion is triggered using end_io call back
> > > > > > function passing from ext4 fs to direct IO.
> > > > > > 
> > > > > > 3) For already fallocated extent, at the time try to map the fallocated
> > > > > > extent, we will split the fallocated extent as necessary, mark the
> > > > > > to-write fallocated extent mapped but still remains unwritten,
> > > > > > insert the splitted extents, to prevent ENOSPC later.
> > > > > > 
> > > > > > This first patch does 1) and 2), the second patch does 3)
> > > > > > 
> > > > > > Patch against ext4 patch queue.
> > > > > > 
> > > > > > Comments? 
> > > > > > 
> > > > > > Singed-Off-By: Mingming Cao <cmm@us.ibm.com>
> > > > > > ---
> > > > > >  fs/ext4/ext4.h  |   18 ++++
> > > > > >  fs/ext4/inode.c |  211 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > > > > >  fs/ext4/super.c |   11 ++
> > > > > >  3 files changed, 237 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > Index: linux-2.6.31-rc4/fs/ext4/ext4.h
> > > > > > ===================================================================
> > > > > > --- linux-2.6.31-rc4.orig/fs/ext4/ext4.h	2009-08-09 14:46:10.000000000 -0700
> > > > > > +++ linux-2.6.31-rc4/fs/ext4/ext4.h	2009-08-09 23:13:15.000000000 -0700
> > > > > > @@ -111,6 +111,15 @@ struct ext4_allocation_request {
> > > > > >  	unsigned int flags;
> > > > > >  };
> > > > > >  
> > > > > > +typedef struct ext4_io_end{
> > > > > > +	struct inode		*inode;		/* file being written to */
> > > > > > +	unsigned int		type;		/* unwritten or written */
> > > > > > +	int			error;		/* I/O error code */
> > > > > > +	ext4_lblk_t		offset;		/* offset in the file */
> > > > > > +	size_t			size;		/* size of the extent */
> > > > > > +	struct work_struct	work;		/* data work queue */
> > > > > > +}ext4_io_end_t;
> > > > > > +
> > > > > >  /*
> > > > > >   * Special inodes numbers
> > > > > >   */
> > > > > > @@ -330,8 +339,8 @@ struct ext4_new_group_data {
> > > > > >  	/* Call ext4_da_update_reserve_space() after successfully 
> > > > > >  	   allocating the blocks */
> > > > > >  #define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0008
> > > > > > -
> > > > > > -
> > > > > > +#define EXT4_GET_BLOCKS_DIO_CREATE_EXT		0x0011
> > > > > > +#define EXT4_GET_BLOCKS_DIO_CONVERT_EXT		0x0021
> > > > > >  /*
> > > > > >   * ioctl commands
> > > > > >   */
> > > > > > @@ -960,6 +969,9 @@ struct ext4_sb_info {
> > > > > >  
> > > > > >  	unsigned int s_log_groups_per_flex;
> > > > > >  	struct flex_groups *s_flex_groups;
> > > > > > +
> > > > > > +	/* workqueue for dio unwritten */
> > > > > > +	struct workqueue_struct *dio_unwritten_wq;
> > > > > >  };
> > > > > >  
> > > > > >  static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
> > > > > > @@ -1650,6 +1662,8 @@ extern void ext4_ext_init(struct super_b
> > > > > >  extern void ext4_ext_release(struct super_block *);
> > > > > >  extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
> > > > > >  			  loff_t len);
> > > > > > +extern int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
> > > > > > +			  loff_t len);
> > > > > >  extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
> > > > > >  			   sector_t block, unsigned int max_blocks,
> > > > > >  			   struct buffer_head *bh, int flags);
> > > > > > Index: linux-2.6.31-rc4/fs/ext4/super.c
> > > > > > ===================================================================
> > > > > > --- linux-2.6.31-rc4.orig/fs/ext4/super.c	2009-08-09 14:51:08.000000000 -0700
> > > > > > +++ linux-2.6.31-rc4/fs/ext4/super.c	2009-08-09 14:51:14.000000000 -0700
> > > > > > @@ -578,6 +578,9 @@ static void ext4_put_super(struct super_
> > > > > >  	struct ext4_super_block *es = sbi->s_es;
> > > > > >  	int i, err;
> > > > > >  
> > > > > > +	flush_workqueue(sbi->dio_unwritten_wq);
> > > > > > +	destroy_workqueue(sbi->dio_unwritten_wq);
> > > > > > +
> > > > > >  	lock_super(sb);
> > > > > >  	lock_kernel();
> > > > > >  	if (sb->s_dirt)
> > > > > > @@ -2781,6 +2784,12 @@ no_journal:
> > > > > >  			clear_opt(sbi->s_mount_opt, NOBH);
> > > > > >  		}
> > > > > >  	}
> > > > > > +	EXT4_SB(sb)->dio_unwritten_wq = create_workqueue("ext4-dio-unwritten");
> > > > > > +	if (!EXT4_SB(sb)->dio_unwritten_wq) {
> > > > > > +		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
> > > > > > +		goto failed_mount_wq;
> > > > > > +	}
> > > > > > +
> > > > > >  	/*
> > > > > >  	 * The jbd2_journal_load will have done any necessary log recovery,
> > > > > >  	 * so we can safely mount the rest of the filesystem now.
> > > > > > @@ -2893,6 +2902,8 @@ cantfind_ext4:
> > > > > >  
> > > > > >  failed_mount4:
> > > > > >  	ext4_msg(sb, KERN_ERR, "mount failed");
> > > > > > +	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
> > > > > > +failed_mount_wq:
> > > > > >  	ext4_release_system_zone(sb);
> > > > > >  	if (sbi->s_journal) {
> > > > > >  		jbd2_journal_destroy(sbi->s_journal);
> > > > > > Index: linux-2.6.31-rc4/fs/ext4/inode.c
> > > > > > ===================================================================
> > > > > > --- linux-2.6.31-rc4.orig/fs/ext4/inode.c	2009-08-09 14:46:32.000000000 -0700
> > > > > > +++ linux-2.6.31-rc4/fs/ext4/inode.c	2009-08-09 14:56:40.000000000 -0700
> > > > > > @@ -37,6 +37,7 @@
> > > > > >  #include <linux/namei.h>
> > > > > >  #include <linux/uio.h>
> > > > > >  #include <linux/bio.h>
> > > > > > +#include <linux/workqueue.h>
> > > > > >  
> > > > > >  #include "ext4_jbd2.h"
> > > > > >  #include "xattr.h"
> > > > > > @@ -3279,6 +3280,8 @@ static int ext4_releasepage(struct page 
> > > > > >  }
> > > > > >  
> > > > > >  /*
> > > > > > + * O_DIRECT for ext3 (or indirect map) based files
> > > > > > + *
> > > > > >   * If the O_DIRECT write will extend the file then add this inode to the
> > > > > >   * orphan list.  So recovery will truncate it back to the original size
> > > > > >   * if the machine crashes during the write.
> > > > > > @@ -3287,7 +3290,7 @@ static int ext4_releasepage(struct page 
> > > > > >   * crashes then stale disk data _may_ be exposed inside the file. But current
> > > > > >   * VFS code falls back into buffered path in that case so we are safe.
> > > > > >   */
> > > > > > -static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
> > > > > > +static ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
> > > > > >  			      const struct iovec *iov, loff_t offset,
> > > > > >  			      unsigned long nr_segs)
> > > > > >  {
> > > > > > @@ -3361,6 +3364,212 @@ out:
> > > > > >  	return ret;
> > > > > >  }
> > > > > >  
> > > > > > +struct workqueue_struct *ext4_unwritten_queue;
> > > > > > +
> > > > > > +/* Maximum number of blocks we map for direct IO at once. */
> > > > > > +
> > > > > > +static int ext4_get_block_dio_write(struct inode *inode, sector_t iblock,
> > > > > > +		   struct buffer_head *bh_result, int create)
> > > > > > +{
> > > > > > +	handle_t *handle = NULL;
> > > > > > +	int ret = 0;
> > > > > > +	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> > > > > > +	int dio_credits;
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * DIO VFS code passes create = 0 flag for write to
> > > > > > +	 * the middle of file. It does this to avoid block
> > > > > > +	 * allocation for holes, to prevent expose stale data
> > > > > > +	 * out when there is parallel buffered read (which does
> > > > > > +	 * not hold the i_mutex lock) while direct IO write has
> > > > > > +	 * not completed. DIO request on holes finally falls back
> > > > > > +	 * to buffered IO for this reason.
> > > > > > +	 *
> > > > > > +	 * For ext4 extent based file, since we support fallocate,
> > > > > > +	 * new allocated extent as uninitialized, for holes, we
> > > > > > +	 * could fallocate blocks for holes, thus parallel
> > > > > > +	 * buffered IO read will zero out the page when read on
> > > > > > +	 * a hole while parallel DIO write to the hole has not completed.
> > > > > > +	 *
> > > > > > +	 * when we come here, we know it's a direct IO write,
> > > > > > +	 * so it's safe to override the create flag from VFS.
> > > > > > +	 */
> > > > > > +	create = EXT4_GET_BLOCKS_DIO_CREATE_EXT;
> > > > > > +
> > > > > > +	if (max_blocks > DIO_MAX_BLOCKS)
> > > > > > +		max_blocks = DIO_MAX_BLOCKS;
> > > > > > +	dio_credits = ext4_chunk_trans_blocks(inode, max_blocks);
> > > > > > +	handle = ext4_journal_start(inode, dio_credits);
> > > > > > +	if (IS_ERR(handle)) {
> > > > > > +		ret = PTR_ERR(handle);
> > > > > > +		goto out;
> > > > > > +	}
> > > > > > +	ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
> > > > > > +			      create);
> > > > > > +	if (ret > 0) {
> > > > > > +		bh_result->b_size = (ret << inode->i_blkbits);
> > > > > > +		ret = 0;
> > > > > > +	}
> > > > > > +	ext4_journal_stop(handle);
> > > > > > +out:
> > > > > > +	return ret;
> > > > > > +}
> > > > > > +
> > > > > > +static int ext4_get_block_dio_read(struct inode *inode, sector_t iblock,
> > > > > > +		   struct buffer_head *bh_result, int create)
> > > > > > +{
> > > > > > +	int ret = 0;
> > > > > > +	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> > > > > > +	handle_t *handle = NULL;
> > > > > > +
> > > > > > +	ret = ext4_get_blocks(handle, inode, iblock, max_blocks, bh_result,
> > > > > > +			      create);
> > > > > > +	if (ret > 0) {
> > > > > > +		bh_result->b_size = (ret << inode->i_blkbits);
> > > > > > +		ret = 0;
> > > > > > +	}
> > > > > > +	return ret;
> > > > > > +}
> > > > >   Huh, what's the purpose of the above function? We can use normal
> > > > > get_block, can't we?
> > > > > 
> > > > 
> > > > This is pretty much a wrapper of this normal get_block function, except
> > > > here we need to store the space mapped in b_size, DIO will check that.
> > >   But ext4_get_block() will do exactly the same, won't it?
> > > 
> > Ah, it does the same, with a little more check for "read" or "write"...I
> > am fine to use ext4_get_block() directly. Will change it as you
> > suggested.
> > 
> > > > > > +
> > > > > > +
> > > > > > +#define		DIO_UNWRITTEN	0x1
> > > > > > +
> > > > > > +/*
> > > > > > + * IO write completion for unwritten extents.
> > > > > > + *
> > > > > > + * check a range of space and convert unwritten extents to written.
> > > > > > + */
> > > > > > +static void ext4_end_dio_unwritten(struct work_struct *work)
> > > > > > +{
> > > > > > +	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
> > > > > > +	struct inode *inode = io->inode;
> > > > > > +	loff_t offset = io->offset;
> > > > > > +	size_t size = io->size;
> > > > > > +	int ret = 0;
> > > > > > +
> > > > > > +	ret = ext4_convert_unwritten_extents(inode, offset, size);
> > > > > > +
> > > > > > +	if (ret < 0)
> > > > > > +		printk(KERN_EMERG "%s: failed to convert unwritten"
> > > > > > +			"extents to written extents, error is %d\n",
> > > > > > +                       __func__, ret);
> > > > > > +	kfree(io);
> > > > > > +}
> > > > >   Looking at ext4_convert_unwritten_extents(), you definitely miss some
> > > > > locking. Since this is called completely asynchronously, you have to
> > > > > protect against racing truncates and basically anything can happen with
> > > > > the inode in the mean time. 
> > > > 
> > > > extents tree update is protected by the i_data_sem which will be hold at
> > > > the ext4_get_blocks() called from ext4_convert_unwritten_extents. 
> > >   Ah, I've missed that.
> > > 
> > > > perhaps should grab the i_mutex() which protects the inode update?
> > >   Probably we should because we update i_disksize inside
> > > ext4_convert_unwritten_extents(). BTW, where do we update i_size? The same
> > > place where we update i_disksize is probably right and that definitely
> > > needs i_mutex.
> > > 
> > 
> > We do update i_size in generic_file_direct_write(), there I think proper
> > locking (i_mutex lock) is hold.
> > 
> > For i_disksize update, with this patch, we call ext4_update_i_disksize()
> > from ext4_convert_unwritten_extents(), at the end of IO is completed.
> > ext4_update_i_disksize() grab the i_data_sem to prevent race with
> > truncate.
> > 
> > Now I think we are fine with race with truncate... no?
>   I don't think we are fine - i_disksize gets updated without i_data_sem
> being held in ext4_setattr() so you can race with it. I'm not sure how
> exactly locking rules for ext4 look like wrt. i_disksize update but either
> your code or ext4_setattr() need to be changed.

then ext4_setattr() race with other places using
ext4_update_i_disksize() (e.g. fallocate) already. we need to fix
ext4_setattr and probably other places where i_disksize is updated
without holding i_data_sem.

>   Actually, probably you should hold i_mutex until the io is finished -
> otherwise a truncate against the file can be started before the io is
> finished and actually nothing prevents it from finishing before your end_io
> callback gets processed. Then the extent conversion will get confused I
> expect because it won't find extents it should convert.
> 

DIO already did that:) i_mutex is hold during the whole direct IO,
before return back to user, in the non AIO case.

> > > > > It needn't be cached in the memory anymore!
> > > > 
> > > > Right, we probably need to increase the reference to the inode before
> > > > submit the IO, so the inode would not be push out of cache before IO
> > > > completed.
> > >   Yes, that's possible but then you have to be prepared to handle deletes
> > > of an inode from your worker thread because it can drop the last reference
> > > to an already deleted inode.
> > > 
> > > > >   Also fsync() has to flush all the updates for the inode it has in the
> > > > > workqueue... Ditto for ext4_sync_fs().
> > > > > 
> > > > 
> > > > I think we discussed about this before, and it seems there is no clear
> > > > defination the DIO forces metadata update sync to disk before returns
> > > > back to user apps... If we do force this in ext4 &DIO, doing fsync() on
> > > > every DIO call is expensive.
> > >   No, I meant something else:
> > > fd = open("file", O_DIRECT | O_RDWR);
> > > write(fd, buf, size);
> > > fsync(fd)
> > > 
> > >   After fsync(fd) we *must* have everything on disk and reachable even if
> > > we crashed just after fsync(). So conversion of extents from uninitialized
> > > to initialized must happen during fsync() and it does not so far because we
> > > have no connection from an inode to the work queued to the worker thread.
> > > 
> > 
> > Are you worried about AIO DIO case?
> > 
> > Because for non AIO case, when DIO returns back to user, the data IO has
> > already completed, and the conversion of extents from uninitialized to
> > initialized has already being kicked by flush_workqueue(). Since the
> > conversion is being journaled, the aftweward fsync() should able to
> > commit all transactions, thus force the conversion to be complete on
> > disk after fsync.
>   Yes, you are right, this case is fine.
> 
> > For the AIO DIO case, yeah I agree there might be a issue....  Hmm.. if
> > we do fsync() after AIO DIO, currently I couldn't see any way fsync()
> > could ensure all the pending data IOs from AIO DIO path would reach to
> > disk...
> > 
> > if there is a way fsycn() could wait for all pending data IOs  from AIO
> > DIO to complete, then end_io callback would able to trigger the
> > conversion, and fsycn() would able to flush the metedata update hit to
> > disk.
>   Well, thinking about this again, fsync() does not have to wait for
> pending AIO - we never guaranteed anything about what fsync() does to such
> requests. But once you complete the AIO (and thus userspace can know that
> it is done), you have to make sure that fsync() flushes all the work
> queued in the workqueue connected with this AIO.
> 

I just realize, why don't we flush the work in the workqueue with this
AIO at the IO completion time (but not ext4_direct_IO time)? Since the
work just does conversion but not the full journal commit. That would
work if there is fsync() after the AIO is completed.

> > > > > > +
> > > > > > +static ext4_io_end_t *ext4_init_io_end (struct inode *inode, unsigned int type)
> > > > > > +{
> > > > > > +	ext4_io_end_t *io = NULL;
> > > > > > +
> > > > > > +	io = kmalloc(sizeof(*io), GFP_NOFS);
> > > > > > +
> > > > > > +	if (io) {
> > > > > > +		io->inode = inode;
> > > > > > +		io->type = type;
> > > > > > +		io->offset = 0;
> > > > > > +		io->size = 0;
> > > > > > +		io->error = 0;
> > > > > > +		INIT_WORK(&io->work, ext4_end_dio_unwritten);
> > > > > > +	}
> > > > > > +
> > > > > > +	return io;
> > > > > > +}
> > > > > > +
> > > > > > +static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> > > > > > +			    ssize_t size, void *private)
> > > > > > +{
> > > > > > +        ext4_io_end_t *io_end = iocb->private;
> > > > > > +	struct workqueue_struct *wq;
> > > > > > +
> > > > > > +	/* if not hole or unwritten extents, just simple return */
> > > > > > +	if (!io_end || !size)
> > > > > > +		return;
> > > > > > +	io_end->offset = offset;
> > > > > > +	io_end->size = size;
> > > > > > +	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> > > > > > +
> > > > > > +	/* We need to convert unwritten extents to written */
> > > > > > +	queue_work(wq, &io_end->work);
> > > > > > +
> > > > > > +        if (is_sync_kiocb(iocb))
> > > > > > +		flush_workqueue(wq);
> > > > >   I don't think you can flush_workqueue here. end_io is called from
> > > > > interrupt context and flush_workqueue blocks for a long time...
> > > > > The wait should be done in ext4_direct_IO IMHO...
> > > > > 
> > > > 
> > > > Okay, I will move it to ext4_direct_IO(), hmm..I think that is fine with
> > > > AIO path as the is_sync_kiocb(iocb) will avoid that.
> > >   Yes, this concerns standard IO.
> > > 
> > > > If flush workqueue just kick off the work on the workqueue but not wait
> > > > for it to complete (no fsync()), would that still be a big concern? BTW,
> > >   Waking up the worker thread is certainly fine even from the end_io.
> > > 
> > 
> > Okay, I guess I didn't explain this well with my patch. The
> > flush_workqueue() here will call ext4_convert_unwritten_extents(), which
> > just does the conversion, but ext4_convert_unwritten_extents() does not
> > force the journal commit.
> > 
> > > > the flush workqueue only called when file is opened with sync mode.
> > >   I don't think so - is_sync_kiocb() just means that it is a standard
> > > read/write and not one submitted via the aio interface (io_submit syscall
> > > etc.).
> > > 
> > 
> > ah okay, I responsed too soon. yeah, for the DIO regular case (even if
> > file doesn't open with sync mode), we do ensure the worker thread kick
> > off the conversion and log the conversion. That's right behavior, I
> > think.
>   Yes, this part of your patch is correct. Ted explained to me what I have
> missed.
> 
> > > > > > +
> > > > > > +	iocb->private = NULL;
> > > > > > +}
> > > > > > +/*
> > > > > > + * For ext4 extent files, ext4 will do direct-io write to holes,
> > > > > > + * preallocated extents, and those write extend the file, no need to
> > > > > > + * fall back to buffered IO.
> > > > > > + *
> > > > > > + * If there is block allocation needed(holes, EOF write), we fallocate
> > > > > > + * those blocks, mark them as unintialized
> > > > > > + * If those blocks were preallocated, we mark sure they are splited, but
> > > > > > + * still keep the range to write as unintialized.
> > > > > > + *
> > > > > > + * When end_io call back function called at the last IO complete time,
> > > > > > + * those extents will be converted to written extents.
> > > > > > + *
> > > > > > + */
> > > > > > +static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
> > > > > > +			      const struct iovec *iov, loff_t offset,
> > > > > > +			      unsigned long nr_segs)
> > > > > > +{
> > > > > > +	struct file *file = iocb->ki_filp;
> > > > > > +	struct inode *inode = file->f_mapping->host;
> > > > > > +	ssize_t ret;
> > > > > > +
> > > > > > +	if (rw == WRITE) {
> > > > > > +		/*
> > > > > > + 		 * For DIO we fallocate blocks for holes and end of file
> > > > > > + 		 * write. Those fallocated extents are marked as uninitialized
> > > > > > + 		 * to prevent paralel buffered read to expose the stale data
> > > > > > + 		 * before DIO complete the data IO.
> > > > > > + 		 * as for previously fallocated extents, ext4 get_block
> > > > > > + 		 * will just simply mark the buffer mapped but still
> > > > > > + 		 * keep the extents uninitialized.
> > > > > > + 		 *
> > > > > > + 		 * At the end of IO, the ext4 end_io callback function
> > > > > > + 		 * will convert those unwritten extents to written,
> > > > > > + 		 * and update on disk file size if the DIO expands the file.
> > > > > > + 		 *
> > > > > > + 		 */
> > > > > > +		iocb->private = ext4_init_io_end(inode, DIO_UNWRITTEN);
> > > > > > +		if (!iocb->private)
> > > > > > +			return -ENOMEM;
> > > > > > +
> > > > > > +		ret = blockdev_direct_IO(rw, iocb, inode,
> > > > > > +					 inode->i_sb->s_bdev, iov,
> > > > > > +					 offset, nr_segs,
> > > > > > +					 ext4_get_block_dio_write,
> > > > > > +					 ext4_end_io_dio);
> > > > > > +	} else
> > > > > > +		ret = blockdev_direct_IO(rw, iocb, inode,
> > > > > > +					 inode->i_sb->s_bdev, iov,
> > > > > > +					 offset, nr_segs,
> > > > > > +					 ext4_get_block_dio_read, NULL);
> > > > > > +
> > > > > > + 	/*
> > > > > > +	 * In the case of AIO DIO, VFS dio submitted the IO, but it
> > > > > > + 	 * does not wait for io complete. To prevent expose stale
> > > > > > + 	 * data after crash before IO complete,
> > > > > > + 	 * i_disksize needs to be updated at the
> > > > > > + 	 * time all the IO is completed, not here
> > > > > > + 	 */
> > > > >   Yeah, but so far at least ext3_direct_IO and ext4_ind_direct_IO
> > > > > happily update i_size here and noone reported the problem (yet) ;).  The
> > > > > thing is that the current transaction has to commit for stale data to be
> > > > > visible and that sends a barrier which also forces blocks written by
> > > > > direct IO to the persistent storage. So at least if the underlying
> > > > > storage supports barriers, we are fine. If it does not, it could maybe
> > > > > reorder direct IO writes after the journal commit (it need not have
> > > > > reported the direct IO as done so far) and after a crash we would have
> > > > > a problem...
> > > > >   It's just that I'm not sure that all the trouble with end_io and
> > > > > workqueues is worth it... More code = more bugs ;)
> > > > 
> > > > the end_io is there for direct write to fallocate. I am completely sure
> > > > if there is better way? We need to convert the extents to written at the
> > > > end of IO is completed, end_io call back seems works for this purpose.
> > > >
> > > > The workqueue is for AIO case,it would be nice if we could do without it
> > > > for AIO. But read comments from xfs code it seems this is needed if we
> > > > use end_io call back.
> > >   Yes, end_io callback is useful for triggering the conversion or
> > > acknowledging that the transaction with the conversion can be committed
> > > and I'm not against using it. Actually, looking at the XFS code, they also
> > > do flush_workqueue() from the end_io callback. Interesting. I guess I'll
> > > ask them why it's not a problem...
> > >   What I'm concerned about is the fact that we'd do the conversion from
> > > completely asynchronous context and that opens all sorts of races. 
> > 
> > Yeah in the AIO case we do the conversion  from asynchronous context,
> > but for the non AIO case, the conversion is done under process context
> > still. I suspect the AIO DIO today for ext3 update the on disk size
> > before IO is complete is a bigger issue...:)
>   Well, ext3 has a problem that if you do AIO DIO and power fails after
> the transaction is committed but before the data really gets written, then
> we expose stale data after a crash. I didn't see a single report of this
> but in theory the race is there.
>   Your patch closes this hole but we should better not introduce other
> races :).
> 
> > > So I'd
> > > find simpler to do the conversion from ext4_direct_IO and just make sure the
> > > transaction is not committed before the IO is done (essentially what we
> > > currently do with ordered buffers).
> > > 
> > 
> > True, that might workable....I am concerned this won't work for no
> > journal mode, though this mode is not commonly used now.:)
>   Well, if you are running without a journal, you can see stale data after
> a crash - there's no way around it. So just not waiting for anything works
> well.
> 

But in the direct IO case, with the end_io call back, we won't update
i_disksize until IO is completed, you should not see stale data after a
crash, even without journal, am I miss anything?

Mingming

> 									Honza


