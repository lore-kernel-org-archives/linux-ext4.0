From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Return -EINVAL when start is beyond the end of
 fs in ext3_trim_fs()
Date: Wed, 22 Jun 2011 20:26:14 +0200
Message-ID: <20110622182614.GD26160@quack.suse.cz>
References: <1308732669-6674-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab1FVS0S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jun 2011 14:26:18 -0400
Content-Disposition: inline
In-Reply-To: <1308732669-6674-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 22-06-11 10:51:09, Lukas Czerner wrote:
> We should return -EINVAL when the FITRIM parameters are not sane, but
> currently we are exiting silently if start is beyond the end of the
> file system. This commit fixes this so we return -EINVAL as other file
> systems do.
  Thanks. Merged.

								Honza
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> CC: Jan Kara <jack@suse.cz>
> ---
>  fs/ext3/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index fe52297..790cdf3 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -2100,7 +2100,7 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))
>  		return -EINVAL;
>  	if (start >= max_blks)
> -		goto out;
> +		return -EINVAL;
>  	if (start + len > max_blks)
>  		len = max_blks - start;
>  
> -- 
> 1.7.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
