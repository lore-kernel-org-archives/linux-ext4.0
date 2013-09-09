From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix delayed pages writback regression.
Date: Mon, 9 Sep 2013 15:52:21 +0200
Message-ID: <20130909135221.GC1612@quack.suse.cz>
References: <1378697117-5894-1-git-send-email-zheng.z.yan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu,
	lkp@linux.intel.com
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3IINw1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 09:52:27 -0400
Content-Disposition: inline
In-Reply-To: <1378697117-5894-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  Thanks for testing and the report.

On Mon 09-09-13 11:25:17, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Our Linux Kernel Performance project found that commit 4e7ea81db5
> (ext4: restructure writeback path) indroduced a read performance
> regression. After the commit, ext4 does not merge adjacent delayed
  Really "read performance regression"? Do you mean that the file was more
fragmented and therefore reading got slower? Or how exactly did a change in
writeback path cause read perfomance regression?

Also what benchmark and HW configuration do you use for testing? And how
big regression do you see exactly? I can try to reproduce the results...

> pages during writeback. The regression is caused by the "buffer
> mapped" check in mpage_add_bh_to_extent(), delayed dirty pages are
> not mapped.
  This shouldn't happen. As a comment before ext4_da_get_block_prep()
describes, delayed allocated buffers should be marked with BH_Mapped |
BH_New | BH_Delay. So if you can see BH_Delay buffers without BH_Mapped set
that's a bug we should find.

								Honza
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  fs/ext4/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c79fd7d..f2034cb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1944,8 +1944,9 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
>  	struct ext4_map_blocks *map = &mpd->map;
>  
>  	/* Buffer that doesn't need mapping for writeback? */
> -	if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
> -	    (!buffer_delay(bh) && !buffer_unwritten(bh))) {
> +	if (!buffer_dirty(bh) ||
> +	    (!buffer_mapped(bh) &&
> +	     !buffer_delay(bh) && !buffer_unwritten(bh))) {
>  		/* So far no extent to map => we write the buffer right away */
>  		if (map->m_len == 0)
>  			return true;
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
