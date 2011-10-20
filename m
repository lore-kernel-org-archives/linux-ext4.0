From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: Allow quota file use root reservation
Date: Fri, 21 Oct 2011 01:36:21 +0200
Message-ID: <20111020233621.GH20542@quack.suse.cz>
References: <1319019383-12603-1-git-send-email-dmonakhov@openvz.org>
 <1319019383-12603-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab1JTXgW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Oct 2011 19:36:22 -0400
Content-Disposition: inline
In-Reply-To: <1319019383-12603-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 19-10-11 14:16:23, Dmitry Monakhov wrote:
> Quota file is fs's metadata, so it is reasonable  to permit use
> root resevation if necessary. This patch fix 265'th xfstest failure
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext3/balloc.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 6386d76..5430559 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
...
> @@ -1546,7 +1546,7 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
>  	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
>  		my_rsv = &block_i->rsv_window_node;
>  
> -	if (!ext3_has_free_blocks(sbi)) {
> +	if (!ext3_has_free_blocks(sbi, IS_NOQUOTA(inode))) {
>  		*errp = -ENOSPC;
>  		goto out;
>  	}
  Hmph, using IS_NOQUOTA() for a detection of quota files is a hack. But if
we look at it like "if a file is extempted from quota, it can be as well
allowed to use reserved blocks" then it makes some sense. So I'll take the
patch. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
