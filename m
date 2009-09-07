From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2 V3] allow direct IO to fallocate and holes
Date: Mon, 7 Sep 2009 23:57:46 +0200
Message-ID: <20090907215746.GA11748@duck.suse.cz>
References: <1252025090.15321.17.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZIGV5u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Sep 2009 17:57:50 -0400
Content-Disposition: inline
In-Reply-To: <1252025090.15321.17.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Minming,

  the patch looks cleaner now.

On Thu 03-09-09 17:44:50, Mingming wrote:
> Index: linux-2.6.31-rc4/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.31-rc4.orig/fs/ext4/inode.c
> +++ linux-2.6.31-rc4/fs/ext4/inode.c
...
> +#define		DIO_AIO		0x1
  This flag isn't set anywhere...

> +static void ext4_free_io_end(ext4_io_end_t *io)
> +{
> +	kfree(io);
> +}
> +
> +/*
> + * IO write completion for unwritten extents.
> + *
> + * check a range of space and convert unwritten extents to written.
> + */
> +static void ext4_end_dio_unwritten(struct work_struct *work)
> +{
> +	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
> +	struct inode *inode = io->inode;
> +	loff_t offset = io->offset;
> +	size_t size = io->size;
> +	int ret = 0;
> +	int aio = io->flag & DIO_AIO;
> +
> +	if (aio)
> +		mutex_lock(&inode->i_mutex);
> +	if (offset + size <= i_size_read(inode))
> +		ret = ext4_convert_unwritten_extents(inode, offset, size);
> +
> +	if (ret < 0)
> +		printk(KERN_EMERG "%s: failed to convert unwritten"
> +			"extents to written extents, error is %d\n",
> +                       __func__, ret);
> +
> +	ext4_free_io_end(io);
> +	if (aio)
> +		mutex_unlock(&inode->i_mutex);
> +}
> +
> +static ext4_io_end_t *ext4_init_io_end (struct inode *inode, unsigned int flag)
> +{
> +	ext4_io_end_t *io = NULL;
> +
> +	io = kmalloc(sizeof(*io), GFP_NOFS);
> +
> +	if (io) {
> +		io->inode = inode;
  You should __iget() the inode here and iput() it in the end IO handler at
least in the AIO case so that the inode remains pinned in memory.

> +		io->flag = flag;
> +		io->offset = 0;
> +		io->size = 0;
> +		io->error = 0;
> +		INIT_WORK(&io->work, ext4_end_dio_unwritten);
> +	}
> +
> +	return io;
> +}
> +
> +static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> +			    ssize_t size, void *private)
> +{
> +        ext4_io_end_t *io_end = iocb->private;
> +	struct workqueue_struct *wq;
> +
> +	/* if not hole or unwritten extents, just simple return */
> +	if (!io_end || !size || !iocb->private)
> +		return;
> +	io_end->offset = offset;
> +	io_end->size = size;
> +	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> +
> +	/* We need to convert unwritten extents to written */
> +	queue_work(wq, &io_end->work);
> +
> +        if (is_sync_kiocb(iocb))
> +		flush_workqueue(wq);
  You have spaces instead of tabs above.

  I think fsync() still won't work correctly since it can happen user sees
AIO completed, calls fsync() that completes, but the conversion of extents
still has not happened because the conversion thread as not run yet.
  The simple solution would be so flush_workqueue() from ext4_sync_fs()
and ext4_fsync(). But that would needlessly make fsync() wait for
conversion in unrelated files. More sophisticated solution would be to
attach io_end structures to the inode and do the work described by them
in ext4_fsync() (ext4_sync_fs() is fine doing flush_workqueue() since it
has to do all the work anyway). But in this solution you would have to be
careful to avoid races of fsync() and the completion thread.
  Besides these problems the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
