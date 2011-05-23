From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4:Make ext4_split_extent() handle error correctly.
Date: Sun, 22 May 2011 20:51:36 -0400
Message-ID: <20110523005136.GD10009@thunk.org>
References: <BANLkTintPx6Tugitnodou++sLR1m6SOunA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34940 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1EWAvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 20:51:42 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTintPx6Tugitnodou++sLR1m6SOunA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added to the ext4 tree, thanks.

						- Ted

On Sat, May 14, 2011 at 03:05:05PM +0800, Yongqiang Yang wrote:
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/extents.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e363f21..b7b667f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2716,6 +2716,8 @@ static int ext4_split_extent(handle_t *handle,
>  				       EXT4_EXT_MARK_UNINIT2;
>  		err = ext4_split_extent_at(handle, inode, path,
>  				map->m_lblk + map->m_len, split_flag1, flags1);
> +		if (err)
> +			goto out;
>  	}
> 
>  	ext4_ext_drop_refs(path);
> -- 
> 1.7.5.1
> 
> --
