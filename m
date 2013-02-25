From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] ext4: invalidate exntent-status-tree during
 extent_migration
Date: Mon, 25 Feb 2013 19:06:54 +0100
Message-ID: <20130225180654.GB17503@quack.suse.cz>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
 <1361808463-25471-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab3BYSG7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 13:06:59 -0500
Content-Disposition: inline
In-Reply-To: <1361808463-25471-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 25-02-13 20:07:43, Dmitry Monakhov wrote:
> mext_replace_branches() will change inode's extents layout so
> we have to drop corresponding cache.
> 
> TESTCASE:  301'th xfstest was not yet accepted to official xfstest's branch
> and can be found here: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Makes sense. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/move_extent.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index d78c33e..c1f15b2 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -666,6 +666,14 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
>  	int replaced_count = 0;
>  	int dext_alen;
>  
> +	*err = ext4_es_remove_extent(orig_inode, from, count);
> +	if (*err)
> +		goto out;
> +
> +	*err = ext4_es_remove_extent(donor_inode, from, count);
> +	if (*err)
> +		goto out;
> +
>  	/* Get the original extent for the block "orig_off" */
>  	*err = get_ext_path(orig_inode, orig_off, &orig_path);
>  	if (*err)
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
