From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [Cluster-devel] [PATCH 3/4] gfs2: Use generic handlers of
 O_SYNC AIO DIO
Date: Mon, 13 Feb 2012 09:42:18 +0000
Message-ID: <1329126138.2702.4.camel@menhir>
References: <1328889842-23231-1-git-send-email-jack@suse.cz>
	 <1328889842-23231-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Moyer <jmoyer@redhat.com>, cluster-devel@redhat.com,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2BMJlt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 04:41:49 -0500
In-Reply-To: <1328889842-23231-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Acked-by: Steven Whitehouse <swhiteho@redhat.com>

That looks ok to me,

Steve.

On Fri, 2012-02-10 at 17:04 +0100, Jan Kara wrote:
> Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
> file.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/gfs2/aops.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
> index 501e5cb..9c381ff 100644
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


