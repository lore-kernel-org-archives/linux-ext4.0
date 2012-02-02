From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] filemap: don't call generic_write_sync for
 -EIOCBQUEUED
Date: Thu, 2 Feb 2012 18:52:19 +0100
Message-ID: <20120202175219.GB6640@quack.suse.cz>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
 <1327698949-12616-4-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102Ab2BBRwV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Feb 2012 12:52:21 -0500
Content-Disposition: inline
In-Reply-To: <1327698949-12616-4-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 27-01-12 16:15:49, Jeff Moyer wrote:
> As it stands, generic_file_aio_write will call into generic_write_sync
> when -EIOCBQUEUED is returned from __generic_file_aio_write.  EIOCBQUEUED
> indicates that an I/O was submitted but NOT completed.  Thus, we will
> flush the disk cache, potentially before the write(s) even make it to
> the disk!
  Yeah. It seems to be a problem introduced by Tejun's rewrite of barrier
code, right? Before that we'd drain the IO queue when cache flush is issued
and thus effectively wait for IO completion...

>  Up until now, this has been the best we could do, as file
> systems didn't bother to flush the disk cache after an O_SYNC AIO+DIO
> write.  After applying the prior two patches to xfs and ext4, at least
> the major two file systems do the right thing.  So, let's go ahead and
> fix this backwards logic.
  But doesn't this break filesystems which you didn't fix explicitely even
more than they were? You are right they might have sent cache flush too
early but they'd at least propely force all metadata modifications (e.g.
from allocation) to disk. But after this patch O_SYNC will have simply no
effect for these filesystems.

Also I was thinking whether we couldn't implement the fix in VFS. Basically
it would be the same like the fix for ext4. Like having a per-sb workqueue
and queue work calling generic_write_sync() from end_io handler when the
file is O_SYNC? That would solve the issue for all filesystems...

								Honza

> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  mm/filemap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c4ee2e9..004442f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2634,7 +2634,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>  	mutex_unlock(&inode->i_mutex);
>  
> -	if (ret > 0 || ret == -EIOCBQUEUED) {
> +	if (ret > 0) {
>  		ssize_t err;
>  
>  		err = generic_write_sync(file, pos, ret);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
