From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 1/3] ext4: split ext4_file_write into buffered IO
 and direct IO
Date: Wed, 2 May 2012 13:50:22 +0800
Message-ID: <20120502055022.GA10793@gmail.com>
References: <1335584346-8070-1-git-send-email-wenqing.lz@taobao.com>
 <1335584346-8070-2-git-send-email-wenqing.lz@taobao.com>
 <4FA0B400.3090706@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34703 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2EBFnc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 01:43:32 -0400
Received: by ghrr11 with SMTP id r11so275863ghr.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 May 2012 22:43:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FA0B400.3090706@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 02, 2012 at 12:11:44PM +0800, Tao Ma wrote:
> Hi zheng,
> On 04/28/2012 11:39 AM, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > ext4_file_buffered/direct_write are defined in order to split buffered IO and
> > direct IO in ext4.  This patch just refactor some stuff in write path.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/file.c |   66 +++++++++++++++++++++++++++++++++++++------------------
> >  1 files changed, 44 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index cb70f18..e5d6be3 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -89,12 +89,51 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
> >  	return 0;
> >  }
> >  
> > +static inline ssize_t
> > +ext4_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
> > +			 unsigned long nr_segs, loff_t pos)
> > +{
> > +	return generic_file_aio_write(iocb, iov, nr_segs, pos);
> > +}
> any reason you wrap generic_file_aio_write with a new function? I didn't
> see you use it in the following patch either.

Yes, I don't use it in the following patch.  It is defined in order to
be consistent with ext4_file_dio_write and make things clearly.

Regards,
Zheng

> 
> Thanks
> Tao
> > +
> > +static ssize_t
> > +ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
> > +		    unsigned long nr_segs, loff_t pos)
> > +{
> > +	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> > +	int unaligned_aio = 0;
> > +	ssize_t ret;
> > +
> > +	if (!is_sync_kiocb(iocb))
> > +		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
> > +
> > +	/* Unaligned direct AIO must be serialized; see comment above */
> > +	if (unaligned_aio) {
> > +		static unsigned long unaligned_warn_time;
> > +
> > +		/* Warn about this once per day */
> > +		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
> > +			ext4_msg(inode->i_sb, KERN_WARNING,
> > +				 "Unaligned AIO/DIO on inode %ld by %s; "
> > +				 "performance will be poor.",
> > +				 inode->i_ino, current->comm);
> > +		mutex_lock(ext4_aio_mutex(inode));
> > +		ext4_aiodio_wait(inode);
> > +	}
> > +
> > +	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
> > +
> > +	if (unaligned_aio)
> > +		mutex_unlock(ext4_aio_mutex(inode));
> > +
> > +	return ret;
> > +}
> > +
> >  static ssize_t
> >  ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
> >  		unsigned long nr_segs, loff_t pos)
> >  {
> >  	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> > -	int unaligned_aio = 0;
> >  	int ret;
> >  
> >  	/*
> > @@ -114,29 +153,12 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
> >  			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
> >  					      sbi->s_bitmap_maxbytes - pos);
> >  		}
> > -	} else if (unlikely((iocb->ki_filp->f_flags & O_DIRECT) &&
> > -		   !is_sync_kiocb(iocb))) {
> > -		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
> > -	}
> > -
> > -	/* Unaligned direct AIO must be serialized; see comment above */
> > -	if (unaligned_aio) {
> > -		static unsigned long unaligned_warn_time;
> > -
> > -		/* Warn about this once per day */
> > -		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
> > -			ext4_msg(inode->i_sb, KERN_WARNING,
> > -				 "Unaligned AIO/DIO on inode %ld by %s; "
> > -				 "performance will be poor.",
> > -				 inode->i_ino, current->comm);
> > -		mutex_lock(ext4_aio_mutex(inode));
> > -		ext4_aiodio_wait(inode);
> >  	}
> >  
> > -	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
> > -
> > -	if (unaligned_aio)
> > -		mutex_unlock(ext4_aio_mutex(inode));
> > +	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT))
> > +		ret = ext4_file_dio_write(iocb, iov, nr_segs, pos);
> > +	else
> > +		ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
> >  
> >  	return ret;
> >  }
> 
