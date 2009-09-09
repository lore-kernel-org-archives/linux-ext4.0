From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 2/2 V3] allow direct IO to fallocate and holes
Date: Wed, 09 Sep 2009 13:51:02 -0700
Message-ID: <1252529462.19097.170.camel@mingming-laptop>
References: <1252025090.15321.17.camel@mingming-laptop>
	 <20090907215746.GA11748@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:58538 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZIIUvB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Sep 2009 16:51:01 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n89KkY0q012908
	for <linux-ext4@vger.kernel.org>; Wed, 9 Sep 2009 14:46:34 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n89Kp4Kb220314
	for <linux-ext4@vger.kernel.org>; Wed, 9 Sep 2009 14:51:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n89Kp3qf029955
	for <linux-ext4@vger.kernel.org>; Wed, 9 Sep 2009 14:51:04 -0600
In-Reply-To: <20090907215746.GA11748@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-09-07 at 23:57 +0200, Jan Kara wrote:
> Hi Minming,
> 
>   the patch looks cleaner now.
> 

Hi Jan

Thanks for your review:)

> On Thu 03-09-09 17:44:50, Mingming wrote:
> > Index: linux-2.6.31-rc4/fs/ext4/inode.c
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/inode.c
> > +++ linux-2.6.31-rc4/fs/ext4/inode.c
> ...
> > +#define		DIO_AIO		0x1
>   This flag isn't set anywhere...
> 
> > +static void ext4_free_io_end(ext4_io_end_t *io)
> > +{
> > +	kfree(io);
> > +}
> > +
> > +/*
> > + * IO write completion for unwritten extents.
> > + *
> > + * check a range of space and convert unwritten extents to written.
> > + */
> > +static void ext4_end_dio_unwritten(struct work_struct *work)
> > +{
> > +	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
> > +	struct inode *inode = io->inode;
> > +	loff_t offset = io->offset;
> > +	size_t size = io->size;
> > +	int ret = 0;
> > +	int aio = io->flag & DIO_AIO;
> > +
> > +	if (aio)
> > +		mutex_lock(&inode->i_mutex);
> > +	if (offset + size <= i_size_read(inode))
> > +		ret = ext4_convert_unwritten_extents(inode, offset, size);
> > +
> > +	if (ret < 0)
> > +		printk(KERN_EMERG "%s: failed to convert unwritten"
> > +			"extents to written extents, error is %d\n",
> > +                       __func__, ret);
> > +
> > +	ext4_free_io_end(io);
> > +	if (aio)
> > +		mutex_unlock(&inode->i_mutex);
> > +}
> > +
> > +static ext4_io_end_t *ext4_init_io_end (struct inode *inode, unsigned int flag)
> > +{
> > +	ext4_io_end_t *io = NULL;
> > +
> > +	io = kmalloc(sizeof(*io), GFP_NOFS);
> > +
> > +	if (io) {
> > +		io->inode = inode;
>   You should __iget() the inode here and iput() it in the end IO handler at
> least in the AIO case so that the inode remains pinned in memory.
> 

I just tried to add this, but hit some errors.  I will dig more.
> > +		io->flag = flag;
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
> > +
> > +	/* if not hole or unwritten extents, just simple return */
> > +	if (!io_end || !size || !iocb->private)
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
>   You have spaces instead of tabs above.
> 
>   I think fsync() still won't work correctly since it can happen user sees
> AIO completed, calls fsync() that completes, 

hmm, does fsync() ensure user sees AIO data completed?

> but the conversion of extents
> still has not happened because the conversion thread as not run yet.
>   The simple solution would be so flush_workqueue() from ext4_sync_fs()
> and ext4_fsync(). But that would needlessly make fsync() wait for
> conversion in unrelated files. More sophisticated solution would be to
> attach io_end structures to the inode and do the work described by them
> in ext4_fsync() (ext4_sync_fs() is fine doing flush_workqueue() since it
> has to do all the work anyway). But in this solution you would have to be
> careful to avoid races of fsync() and the completion thread.

Yeah maybe link the list of io_end structures to the inode, and use a
lock to protect that link... All AIO related issues (including ext3)
seems should addressed in another patch, you agree? Or we should address
them here?

Mingming
>   Besides these problems the patch looks good.
> 
> 								Honza


