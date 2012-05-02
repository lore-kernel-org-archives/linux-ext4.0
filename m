From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [gnehzuil.liu@gmail.com: Re: [RFC][PATCH 3/3] ext4: add dio
 overwrite nolock]
Date: Thu, 3 May 2012 00:03:56 +0800
Message-ID: <20120502160356.GA3970@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45626 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2EBP5B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 11:57:01 -0400
Received: by pbbrp8 with SMTP id rp8so1261548pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 May 2012 08:57:01 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Sorry, when I reply this mail to the mailing list, I get an error.  So
I resend it to the mailing list.]

----- Forwarded message from Zheng Liu <gnehzuil.liu@gmail.com> -----

Date: Wed, 2 May 2012 23:49:35 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH 3/3] ext4: add dio overwrite nolock

On Wednesday, May 2, 2012, Eric Sandeen wrote:

> On 4/27/12 10:39 PM, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com <javascript:;>>
> >
> > Aligned and overwrite direct IO can be parallelized.  In
> ext4_file_dio_write,
> > we first check whether these conditions are satisfied or not.  If so, we
> unlock
> > the i_mutex and acquire i_data_sem directly.  Meanwhile iocb->private is
> set to
> > indicate that this is a overwrite dio, and it will be processed in
> > ext4_ext_direct_IO.
>
> This copies almost 100 lines of generic_file_aio_write() back into
> ext4.  Do we really need to do this?  Copying core code into the
> fs can be a maintenance nightmare...
>
> I'll have to think more about the big picture and whether or not it's
> possible, but my first reaction is to find a way to leverage or modify
> existing IO code rather than pasting it all into ext4 with changes...


The key issue is file_update_time.  In this function, it starts a new
journal.  It will cause a deadlock because we usually start a new journal
firstly, and then try to lock i_data_sem.  But in overwrite this order is
reversed.  If we can avoid this deadlock, we won't need to copy core code
into ext4.

Regards,
Zheng


>
> -Eric
>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/file.c |  140
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 137 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index e5d6be3..8a5f713 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -100,9 +100,21 @@ static ssize_t
> >  ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
> >                   unsigned long nr_segs, loff_t pos)
> >  {
> > -     struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> > -     int unaligned_aio = 0;
> > +     struct file *file = iocb->ki_filp;
> > +     struct address_space * mapping = file->f_mapping;
> > +     struct inode *inode = file->f_path.dentry->d_inode;
> > +     struct blk_plug plug;
> >       ssize_t ret;
> > +     ssize_t written, written_buffered;
> > +     size_t length = iov_length(iov, nr_segs);
> > +     size_t ocount;          /* original count */
> > +     size_t count;           /* after file limit checks */
> > +     int unaligned_aio = 0;
> > +     int overwrite = 0;
> > +     loff_t *ppos = &iocb->ki_pos;
> > +     loff_t endbyte;
> > +
> > +     BUG_ON(iocb->ki_pos != pos);
> >
> >       if (!is_sync_kiocb(iocb))
> >               unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs,
> pos);
> > @@ -121,7 +133,129 @@ ext4_file_dio_write(struct kiocb *iocb, const
> struct iovec *iov,
> >               ext4_aiodio_wait(inode);
> >       }
> >
> > -     ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
> > +     mutex_lock(&inode->i_mutex);
> > +     blk_start_plug(&plug);
> > +
> > +     ocount = 0;
> > +     ret = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
> > +     if (ret)
> > +             goto unlock_out;
> > +
> > +     count = ocount;
> > +     pos = *ppos;
> > +
> > +     vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> > +
> > +     /* We can write back this queue in page reclaim */
> > +     current->backing_dev_info = mapping->backing_dev_info;
> > +     written = 0;
> > +
> > +     ret = generic_write_checks(file, &pos, &count,
> S_ISBLK(inode->i_mode));
> > +     if (ret)
> > +             goto out;
> > +
> > +     if (count == 0)
> > +             goto out;
> > +
> > +     ret = file_remove_suid(file);
> > +     if (ret)
> > +             goto out;
> > +
> > +     file_update_time(file);
> > +
> > +     iocb->private = NULL;
> > +
> > +     if (!unaligned_aio && !file->f_mapping->nrpages &&
> > +         pos + length < i_size_read(inode) &&
> > +         ext4_should_dioread_nolock(inode)) {
> > +             struct ext4_map_blocks map;
> > +             unsigned int blkbits = inode->i_blkbits;
> > +             int err;
> > +             int len;
> > +
> > +             map.m_lblk = pos >> blkbits;
> > +             map.m_len = (EXT4_BLOCK_ALIGN(pos + length, blkbits) >>
> blkbits)
> > +                     - map.m_lblk;
> > +             len = map.m_len;
> > +
> > +             err = ext4_map_blocks(NULL, inode, &map, 0);
> > +             if (err == len && (!map.m_flags ||
> > +                 map.m_flags & EXT4_MAP_MAPPED)) {
> > +

----- End forwarded message -----
