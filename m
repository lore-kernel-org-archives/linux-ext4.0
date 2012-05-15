From: Jan Kara <jack@suse.cz>
Subject: Re: [patch v2] ext4: potential NULL dereference on error
Date: Tue, 15 May 2012 12:01:55 +0200
Message-ID: <20120515100155.GB22359@quack.suse.cz>
References: <20120514222535.GW5353@quack.suse.cz>
 <20120515084640.GB30265@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab2EOKCJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 May 2012 06:02:09 -0400
Content-Disposition: inline
In-Reply-To: <20120515084640.GB30265@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-05-12 11:46:40, Dan Carpenter wrote:
> The ext4_get_group_desc() function returns NULL on error, and
> ext4_free_inodes_count() function dereferences it without checking.
> There is a check on the next line, but it's too late.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
  Looks good. Thanks! You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
> v2: cleaned up the style
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index a044a9b..ea32d7e 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -508,10 +508,12 @@ fallback_retry:
>  	for (i = 0; i < ngroups; i++) {
>  		grp = (parent_group + i) % ngroups;
>  		desc = ext4_get_group_desc(sb, grp, NULL);
> -		grp_free = ext4_free_inodes_count(sb, desc);
> -		if (desc && grp_free && grp_free >= avefreei) {
> -			*group = grp;
> -			return 0;
> +		if (desc) {
> +			grp_free = ext4_free_inodes_count(sb, desc);
> +			if (grp_free && grp_free >= avefreei) {
> +				*group = grp;
> +				return 0;
> +			}
>  		}
>  	}
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
