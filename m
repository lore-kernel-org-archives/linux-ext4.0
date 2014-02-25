From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] ext3: remove an unneeded check in ext3_new_blocks()
Date: Tue, 25 Feb 2014 10:49:29 +0100
Message-ID: <20140225094929.GA1669@quack.suse.cz>
References: <20140225083945.GC5023@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbaBYJtc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Feb 2014 04:49:32 -0500
Content-Disposition: inline
In-Reply-To: <20140225083945.GC5023@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 25-02-14 11:39:45, Dan Carpenter wrote:
> We know "fatal" is zero here.  The code can be simplified a bit by
> assigning directly.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
  Thanks. Added to my tree.

								Honza

> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 22548f56197b..158b5d4ce067 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -1727,10 +1727,7 @@ allocated:
>  	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
>  
>  	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
> -	err = ext3_journal_dirty_metadata(handle, gdp_bh);
> -	if (!fatal)
> -		fatal = err;
> -
> +	fatal = ext3_journal_dirty_metadata(handle, gdp_bh);
>  	if (fatal)
>  		goto out;
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
