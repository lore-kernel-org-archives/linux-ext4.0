From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3 v2] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
 only file
Date: Wed, 16 Apr 2014 08:02:20 +1000
Message-ID: <20140415220220.GR15995@dastard>
References: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
 <1397580076-19826-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17533 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbaDOWCe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 18:02:34 -0400
Content-Disposition: inline
In-Reply-To: <1397580076-19826-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2014 at 06:41:15PM +0200, Lukas Czerner wrote:
> Currently punch hole and collapse range fallocate operation are not
> allowed on append only file. This should be case for zero range as well.
> Fix it by allowing only pure fallocate (possibly with keep size set).
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: Change the condition to be future proof as suggested by hch
> 
>  fs/open.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 631aea81..fe48b2f 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -254,11 +254,9 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		return -EBADF;
>  
>  	/*
> -	 * It's not possible to punch hole or perform collapse range
> -	 * on append only file
> +	 * We can only allow pure fallocate on append only files
>  	 */
> -	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
> -	    && IS_APPEND(inode))
> +	if (mode & ~FALLOC_FL_KEEP_SIZE && IS_APPEND(inode))

	if ((mode & ~FALLOC_FL_KEEP_SIZE) && IS_APPEND(inode))

gcc normally complains when you mix & and && in the same logic
statement without () to separate the logic. I agree with gcc here,
because the () indicate the intent of the logic and make it easy to
determine that the & and && haven't been mixed up or fat-fingered...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
