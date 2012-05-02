From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 3/3] ext4: add dio overwrite nolock
Date: Wed, 2 May 2012 16:16:26 +0800
Message-ID: <20120502081626.GB11639@gmail.com>
References: <1335584346-8070-1-git-send-email-wenqing.lz@taobao.com>
 <1335584346-8070-4-git-send-email-wenqing.lz@taobao.com>
 <4FA0DB56.5000803@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43540 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2EBIJf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 04:09:35 -0400
Received: by yhmm54 with SMTP id m54so376847yhm.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 May 2012 01:09:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FA0DB56.5000803@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 02, 2012 at 02:59:34PM +0800, Tao Ma wrote:
> On 04/28/2012 11:39 AM, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Aligned and overwrite direct IO can be parallelized.  In ext4_file_dio_write,
> > we first check whether these conditions are satisfied or not.  If so, we unlock
> > the i_mutex and acquire i_data_sem directly.  Meanwhile iocb->private is set to
> > indicate that this is a overwrite dio, and it will be processed in
> > ext4_ext_direct_IO.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/file.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 137 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index e5d6be3..8a5f713 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -100,9 +100,21 @@ static ssize_t
> >  ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
> >  		    unsigned long nr_segs, loff_t pos)
> >  {
> > -	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> > -	int unaligned_aio = 0;
> > +	struct file *file = iocb->ki_filp;
> > +	struct address_space * mapping = file->f_mapping;
> > +	struct inode *inode = file->f_path.dentry->d_inode;
> > +	struct blk_plug plug;
> >  	ssize_t ret;
> > +	ssize_t written, written_buffered;
> > +	size_t length = iov_length(iov, nr_segs);
> > +	size_t ocount;		/* original count */
> > +	size_t count;		/* after file limit checks */
> > +	int unaligned_aio = 0;
> > +	int overwrite = 0;
> > +	loff_t *ppos = &iocb->ki_pos;
> > +	loff_t endbyte;
> > +
> > +	BUG_ON(iocb->ki_pos != pos);
> >  
> >  	if (!is_sync_kiocb(iocb))
> >  		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
> > @@ -121,7 +133,129 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
> >  		ext4_aiodio_wait(inode);
> >  	}
> >  
> > -	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
> > +	mutex_lock(&inode->i_mutex);
> > +	blk_start_plug(&plug);
> > +
> > +	ocount = 0;
> > +	ret = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
> > +	if (ret)
> > +		goto unlock_out;
> > +
> > +	count = ocount;
> > +	pos = *ppos;
> > +
> > +	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> > +
> > +	/* We can write back this queue in page reclaim */
> > +	current->backing_dev_info = mapping->backing_dev_info;
> > +	written = 0;
> > +
> > +	ret = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
> > +	if (ret)
> > +		goto out;
> > +
> > +	if (count == 0)
> > +		goto out;
> > +
> > +	ret = file_remove_suid(file);
> > +	if (ret)
> > +		goto out;
> > +
> > +	file_update_time(file);
> > +
> > +	iocb->private = NULL;
> > +
> > +	if (!unaligned_aio && !file->f_mapping->nrpages &&
> > +	    pos + length < i_size_read(inode) &&
> should be pos + length <= ?
> And inode->i_size should be ok since now we have i_mutex held.

Yes, you are right.

> > +	    ext4_should_dioread_nolock(inode)) {
> > +		struct ext4_map_blocks map;
> > +		unsigned int blkbits = inode->i_blkbits;
> > +		int err;
> > +		int len;
> > +
> > +		map.m_lblk = pos >> blkbits;
> > +		map.m_len = (EXT4_BLOCK_ALIGN(pos + length, blkbits) >> blkbits)
> > +			- map.m_lblk;
> > +		len = map.m_len;
> > +
> > +		err = ext4_map_blocks(NULL, inode, &map, 0);
> > +		if (err == len && (!map.m_flags ||
> > +		    map.m_flags & EXT4_MAP_MAPPED)) {
> could you please add some comments about how and why map.m_flags are
> checked this way?

OK.  I will add some comments to describe it in here.

> > +			overwrite = 1;
> > +			iocb->private = &overwrite;
> > +			mutex_unlock(&inode->i_mutex);
> > +			down_read(&EXT4_I(inode)->i_data_sem);
> Is there any possibility that the metadata is changed after we dropped
> the i_mutex before the down_read?

Yes, the metadata is possible to be changed after we unlocked i_mutex
before acquire i_data_sem.  So I will swap the locking order.

> > +		}
> > +	}
> > +
> > +	if (file->f_mapping->nrpages && overwrite) {
> > +		overwrite = 0;
> > +		up_read(&EXT4_I(inode)->i_data_sem);
> > +		mutex_lock(&inode->i_mutex);
> I am not sure whether it could happen. But if it does happen, should we
> also change the value in iocb->private?

As I said above, if we swap the locking order, I think that it shouldn't
happen.  Certainly, I will set 'iocb->private = NULL' to fix it to
ensure that when it does happen, we can make filesystem do right things.

> > +	}
> > +
> > +	written = generic_file_direct_write(iocb, iov, &nr_segs, pos,
> > +						ppos, count, ocount);
> > +	if (written < 0 || written == count)
> > +		goto out;
> > +	/*
> > +	 * direct-io write to a hole: fall through to buffered I/O
> > +	 * for completing the rest of the request.
> > +	 */
> > +	pos += written;
> > +	count -= written;
> > +	written_buffered = generic_file_buffered_write(iocb, iov,
> > +					nr_segs, pos, ppos, count,
> > +					written);
> If we fall back here, should we re-lock the i_mutex since the buffer
> write isn't guaranteed?

No, we don't need to re-lock i_mutex because dio never falls through to
buffered IO when it is an overwrite.  We do a lookup using
ext4_map_blocks to ensure that it never occurs before we actually issue
a dio.  I will add a BUG_ON to guarantee that it couldn't happen.

Regards,
Zheng

> 
> Thanks
> Tao
> > +	/*
> > +	 * If generic_file_buffered_write() retuned a synchronous error
> > +	 * then we want to return the number of bytes which were
> > +	 * direct-written, or the error code if that was zero.  Note
> > +	 * that this differs from normal direct-io semantics, which
> > +	 * will return -EFOO even if some bytes were written.
> > +	 */
> > +	if (written_buffered < 0) {
> > +		ret = written_buffered;
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * We need to ensure that the page cache pages are written to
> > +	 * disk and invalidated to preserve the expected O_DIRECT
> > +	 * semantics.
> > +	 */
> > +	endbyte = pos + written_buffered - written - 1;
> > +	ret = filemap_write_and_wait_range(file->f_mapping, pos, endbyte);
> > +	if (ret == 0) {
> > +		written = written_buffered;
> > +		invalidate_mapping_pages(mapping,
> > +					 pos >> PAGE_CACHE_SHIFT,
> > +					 endbyte >> PAGE_CACHE_SHIFT);
> > +	} else {
> > +		/*
> > +		 * We don't know how much we wrote, so just return
> > +		 * the number of bytes which were direct-written
> > +		 */
> > +	}
> > +
> > +out:
> > +	current->backing_dev_info = NULL;
> > +	ret = written ? written : ret;
> > +
> > +unlock_out:
> > +	if (overwrite)
> > +		up_read(&EXT4_I(inode)->i_data_sem);
> > +	else
> > +		mutex_unlock(&inode->i_mutex);
> > +
> > +	if (ret > 0 || ret == -EIOCBQUEUED) {
> > +		ssize_t err;
> > +
> > +		err = generic_write_sync(file, pos, ret);
> > +		if (err < 0 && ret > 0)
> > +			ret = err;
> > +	}
> > +	blk_finish_plug(&plug);
> >  
> >  	if (unaligned_aio)
> >  		mutex_unlock(ext4_aio_mutex(inode));
> 
