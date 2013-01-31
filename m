From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4:  ext4_split_extent shoult take care about extent
 zeroout
Date: Thu, 31 Jan 2013 15:18:34 +0100
Message-ID: <20130131141834.GC4612@quack.suse.cz>
References: <1359617098-18451-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	xiaoqiangnk@gmail.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab3AaOSq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 09:18:46 -0500
Content-Disposition: inline
In-Reply-To: <1359617098-18451-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 31-01-13 11:24:58, Dmitry Monakhov wrote:
> We have to update extent's state after first ext4_split_extent_at otherwise this result
> in following trace:
> ->ext4_ext_handle_uninitialized_extents (ex=[1000:20:uninit], lblock 1000, max_blocks 10)
>   ->ext4_split_extent_at(ex=[1000,128], lblk 10010) /// First split
>     ->ext4_ext_split() -> ENOSPC
>     ->ext4_ext_zeroout
>       ->ext4_ext_dirty  -> ex=[1000:20:init]
>   ->ext4_split_extent_at(ex=[1000,128], lblk 10000) /// Second split
>      if(split == ee_block)
>          if (split_flag & EXT4_EXT_MARK_UNINIT2)
>             ext4_ext_mark_uninitialized(ex); ex=[1000:20:uninit] /// The bug!
>      ->ext4_ext_dirty ->ex=[1000:20:uninit]
> 
> At the end ext4_convert_unwritten_extents_endio() will findout large uninitialized
> extent.
  Thanks for debugging this. You fix look correct so you can add
Reviewed-by: Jan Kara <jack@suse.cz>
  but I have to say the above changelog isn't optimal. I had to look into
the code to verify you are actually speaking about what I think you are
speaking. I think there are some mistakes in block numbers and notation for
extents isn't comletely clear either. Can we make the changelog something
like:

When ext4_split_extent_at() ends up doing zeroout & conversion to
initialized instead of split & conversion, ext4_split_extent() gets
confused and can wrongly mark the extent back as uninitialized resulting in
end IO code getting confused from large unwritten extents (it doesn't
result in data corruption mostly by luck).

The example of problematic behavior is:
                           lblk len              lblk len
  ext4_split_extent() (ex=[1000,30,uninit], map=[1010,10])
    ext4_split_extent_at() (split [1000,30,uninit] at 1020)
      ext4_ext_insert_extent() -> ENOSPC
      ext4_ext_zeroout()
        -> extent [1000,30] is now initialized
    ext4_split_extent_at() (split [1000,30,init] at 1010,
			    MARK_UNINIT1 | MARK_UNINIT2)
      -> extent is split and parts marked as uninitialized

Fix the problem by rechecking extent type after the first
ext4_split_extent_at() returns.
---

What do you think? BTW: we don't have to further try to split the extent
once it gets initialized do we? For now I'd keep your fix just to make
ext4_split_extent() generic but noone really calls that function for
initialized extent or is interested in splitting once the extent gets
initialized. That code seriously needs some diet...

								Honza

> 
> TESTCASE: https://github.com/dmonakhov/xfstests/commit/1a1c4f337d4d198803436c63a56625b1a78d8a5e
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 97cac01..7a3f679 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3091,18 +3091,24 @@ static int ext4_split_extent(handle_t *handle,
>  		if (err)
>  			goto out;
>  	}
> -
> +	/* Update path is required because previous ext4_split_extent_at() may
> +	 * result in split of original leaf or extent zeroout.
> +	 */
  Style nit comment should look like:
	/*
	 * Update path is required because previous ext4_split_extent_at() may
	 * result in split of original leaf or extent zeroout.
	 */

>  	ext4_ext_drop_refs(path);
>  	path = ext4_ext_find_extent(inode, map->m_lblk, path);
>  	if (IS_ERR(path))
>  		return PTR_ERR(path);
> +	depth = ext_depth(inode);
> +	ex = path[depth].p_ext;
> +	uninitialized = ext4_ext_is_uninitialized(ex);
>  
>  	if (map->m_lblk >= ee_block) {
>  		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT;
> -		if (uninitialized)
> +		if (uninitialized) {
>  			split_flag1 |= EXT4_EXT_MARK_UNINIT1;
> -		if (split_flag & EXT4_EXT_MARK_UNINIT2)
> -			split_flag1 |= EXT4_EXT_MARK_UNINIT2;
> +			if (split_flag & EXT4_EXT_MARK_UNINIT2)
> +				split_flag1 |= EXT4_EXT_MARK_UNINIT2;
> +		}
>  		err = ext4_split_extent_at(handle, inode, path,
>  				map->m_lblk, split_flag1, flags);
>  		if (err)
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
