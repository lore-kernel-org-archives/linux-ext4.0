From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH 3/7] gfs2: Use generic handlers of O_SYNC AIO DIO
Date: Mon, 02 Apr 2012 15:29:31 +0100
Message-ID: <1333376971.2701.26.camel@menhir>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
	 <1333058705-31512-4-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, jack@suse.cz, hch@infradead.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab2DBO3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 10:29:41 -0400
In-Reply-To: <1333058705-31512-4-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, 2012-03-29 at 18:05 -0400, Jeff Moyer wrote:
> From: Jan Kara <jack@suse.cz>
> 
> Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
> file.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.

> ---
>  fs/gfs2/aops.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index 38b7a74..2589781 100644
> --- a/fs/gfs2/aops.c
> +++ b/fs/gfs2/aops.c
> @@ -1034,7 +1034,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
>  
>  	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
>  				  offset, nr_segs, gfs2_get_block_direct,
> -				  NULL, NULL, 0);
> +				  NULL, NULL, DIO_SYNC_WRITES);
>  out:
>  	gfs2_glock_dq_m(1, &gh);
>  	gfs2_holder_uninit(&gh);


