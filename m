From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix dirty pages writback regression.
Date: Tue, 10 Sep 2013 11:00:44 +0200
Message-ID: <20130910090044.GB894@quack.suse.cz>
References: <1378778578-5000-1-git-send-email-zheng.z.yan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu,
	lkp@linux.intel.com
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab3IJJAr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Sep 2013 05:00:47 -0400
Content-Disposition: inline
In-Reply-To: <1378778578-5000-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-09-13 10:02:58, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Our Linux Kernel Performance project found that commit 4e7ea81db5
> (ext4: restructure writeback path) indroduced regression. After
> the commit, ext4 does not merge adjacent mapped dirty pages during
> writeback. The "!buffer_delay(bh) && !buffer_unwritten(bh)" check
> in mpage_add_bh_to_extent() prevents the merging.
>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  fs/ext4/inode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c79fd7d..bfeb8b2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1944,8 +1944,7 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
>  	struct ext4_map_blocks *map = &mpd->map;
>  
>  	/* Buffer that doesn't need mapping for writeback? */
> -	if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
> -	    (!buffer_delay(bh) && !buffer_unwritten(bh))) {
> +	if (!buffer_dirty(bh) || !buffer_mapped(bh)) {
  Sadly it isn't that easy. The condition is there for a reason... The
reason is that we are looking for an extent to map. When we already have
some buffer to map and then there is buffer which doesn't need mapping we
cannot just add it to the extent because then we would allocate too many
blocks. Also the transaction credits we have reserved are just for
allocation of one extent and its possible conversion from unwritten to
written extent. So that's another reason why you cannot arbitrarily merge
allocated and unallocated buffers or written and unwritten buffers.

Now also I'm somewhat surprised that this condition is causing a regression
because it was also present in the previous version of the code although it
was there in a different place and in a slightly different form. I'll try to
reproduce results using your fio script and will have a look at what is
causing the problem.

								Honza

>  		/* So far no extent to map => we write the buffer right away */
>  		if (map->m_len == 0)
>  			return true;
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
