From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: ext4_split_extent shoult take care about extent
 zeroout v2
Date: Fri, 01 Feb 2013 10:09:34 -0600
Message-ID: <510BE8BE.6090209@redhat.com>
References: <1359643738-22435-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	xiaoqiangnk@gmail.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab3BAQK3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2013 11:10:29 -0500
In-Reply-To: <1359643738-22435-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/31/13 8:48 AM, Dmitry Monakhov wrote:
> When ext4_split_extent_at() ends up doing zeroout & conversion to
> initialized instead of split & conversion, ext4_split_extent() gets
> confused and can wrongly mark the extent back as uninitialized resulting in
> end IO code getting confused from large unwritten extents and may result in
> data loss.
> 
> The example of problematic behavior is:
> 			    lblk len              lblk len
>   ext4_split_extent() (ex=[1000,30,uninit], map=[1010,10])
>     ext4_split_extent_at() (split [1000,30,uninit] at 1020)
>       ext4_ext_insert_extent() -> ENOSPC
>       ext4_ext_zeroout()
> 	 -> extent [1000,30] is now initialized
>     ext4_split_extent_at() (split [1000,30,init] at 1010,
> 			     MARK_UNINIT1 | MARK_UNINIT2)
>       -> extent is split and parts marked as uninitialized
> 
> Fix the problem by rechecking extent type after the first
> ext4_split_extent_at() returns. None of split_flags can not be applied to
> initialized extent so this patch also add BUG_ON to prevent similar issues
> in future.
> 
> TESTCASE: https://github.com/dmonakhov/xfstests/commit/1a1c4f337d4d198803436c63a56625b1a78d8a5e

Dmitry, thanks - want to send that testcase (and any others you've collected
that aren't in the sgi repo) to xfs@oss.sgi.com?

Thanks,
-Eric

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |   22 ++++++++++++++++------
>  1 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index fd51469..05222d5 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2982,6 +2982,10 @@ static int ext4_split_extent_at(handle_t *handle,
>  	newblock = split - ee_block + ext4_ext_pblock(ex);
>  
>  	BUG_ON(split < ee_block || split >= (ee_block + ee_len));
> +	BUG_ON(!ext4_ext_is_uninitialized(ex) &&
> +	       split_flag & (EXT4_EXT_MAY_ZEROOUT |
> +			     EXT4_EXT_MARK_UNINIT1 |
> +			     EXT4_EXT_MARK_UNINIT2));
>  
>  	err = ext4_ext_get_access(handle, inode, path + depth);
>  	if (err)
> @@ -3091,18 +3095,24 @@ static int ext4_split_extent(handle_t *handle,
>  		if (err)
>  			goto out;
>  	}
> -
> +	/*
> +	 * Update path is required because previous ext4_split_extent_at() may
> +	 * result in split of original leaf or extent zeroout.
> +	 */
>  	ext4_ext_drop_refs(path);
>  	path = ext4_ext_find_extent(inode, map->m_lblk, path);
>  	if (IS_ERR(path))
>  		return PTR_ERR(path);
> +	depth = ext_depth(inode);
> +	ex = path[depth].p_ext;
> +	uninitialized = ext4_ext_is_uninitialized(ex);
> +	split_flag1 = 0;
>  
>  	if (map->m_lblk >= ee_block) {
> -		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT;
> -		if (uninitialized)
> -			split_flag1 |= EXT4_EXT_MARK_UNINIT1;
> -		if (split_flag & EXT4_EXT_MARK_UNINIT2)
> -			split_flag1 |= EXT4_EXT_MARK_UNINIT2;
> +		if (uninitialized) {
> +			split_flag1 = EXT4_EXT_MARK_UNINIT1;
> +			split_flag1 |= split_flag & (EXT4_EXT_MAY_ZEROOUT | EXT4_EXT_MARK_UNINIT2);
> +		}
>  		err = ext4_split_extent_at(handle, inode, path,
>  				map->m_lblk, split_flag1, flags);
>  		if (err)
> 

