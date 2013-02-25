From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] ext4: disable merging of uninitialized extents
Date: Mon, 25 Feb 2013 19:09:46 +0100
Message-ID: <20130225180946.GD17503@quack.suse.cz>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
 <1361808463-25471-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759140Ab3BYSJt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 13:09:49 -0500
Content-Disposition: inline
In-Reply-To: <1361808463-25471-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 25-02-13 20:07:40, Dmitry Monakhov wrote:
> Derived from Jan's patch:http://permalink.gmane.org/gmane.comp.file-systems.ext4/36470
> 
> Merging of uninitialized extents creates all sorts of interesting race
> possibilities when writeback / DIO races with fallocate. Thus
> ext4_convert_unwritten_extents_endio() has to deal with a case where
> extent to be converted needs to be split out first. That isn't nice
> for two reasons:
> 
> 1) It may need allocation of extent tree block so ENOSPC is possible.
> 2) It complicates end_io handling code
> 
> So we disable merging of uninitialized extents which allows us to simplify
> the code. Extents will get merged after they are converted to initialized
> ones.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3bd3ca5..1d37f2d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1584,10 +1584,12 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
>  	unsigned short ext1_ee_len, ext2_ee_len, max_len;
>  
>  	/*
> -	 * Make sure that either both extents are uninitialized, or
> -	 * both are _not_.
> +	 * Make sure that both extents are initialized. We don't merge
> +	 * uninitialized extents so that we can be sure that end_io code has
> +	 * the extent that was written properly split out and conversion to
> +	 * initialized is trivial.
>  	 */
> -	if (ext4_ext_is_uninitialized(ex1) ^ ext4_ext_is_uninitialized(ex2))
> +	if (ext4_ext_is_uninitialized(ex1) || ext4_ext_is_uninitialized(ex2))
>  		return 0;
>  
>  	if (ext4_ext_is_uninitialized(ex1))
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
