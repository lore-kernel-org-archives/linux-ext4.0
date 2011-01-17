From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: reduce redundant check of '*options'
Date: Mon, 17 Jan 2011 18:02:03 +0100
Message-ID: <20110117170203.GF5294@quack.suse.cz>
References: <1294922362-2237-1-git-send-email-xu.simon@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Simon Xu <xu.simon@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1AQRCH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jan 2011 12:02:07 -0500
Content-Disposition: inline
In-Reply-To: <1294922362-2237-1-git-send-email-xu.simon@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 13-01-11 20:39:22, Simon Xu wrote:
> We don't need to check whether '*options' equals to ',' twice.
Well, but the code is so rarely executed that even if the compiler would
not be able to optimize out the second test, it would not matter. And the
code is not better readable afterwards either. So I find this more or less
unnecessary code churn...

Seriously, if you want to do some useful fixing then have a look for
example at making ext3/4 (in fact JBD/JBD2) handle transaction allocation
failures gratefully.  Currently we just loop in start_this_handle()
infinitely until we can make the allocation which is a bit dumb. So it
would be good, to make as many places as possible able to handle ENOMEM
from start_this_handle() and propagate the error to user space. In some
cases, it might not be easily possible (e.g. during writeout of dirty
memory, where proper handling needs more thought) but lots of cases
should be rather simple and need just auditing the code paths. Thanks.

								Honza
> 
> Signed-off-by: Simon Xu <xu.simon@oracle.com>
> ---
>  fs/ext2/super.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 7731695..bd5b66b 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -377,13 +377,13 @@ static unsigned long get_sb_block(void **data)
>  		return 1;	/* Default location */
>  	options += 3;
>  	sb_block = simple_strtoul(options, &options, 0);
> -	if (*options && *options != ',') {
> +	if (*options == ',') {
> +		options++;
> +	} else if (*options) {
>  		printk("EXT2-fs: Invalid sb specification: %s\n",
>  		       (char *) *data);
>  		return 1;
>  	}
> -	if (*options == ',')
> -		options++;
>  	*data = (void *) options;
>  	return sb_block;
>  }
> -- 
> 1.7.3.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
