From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix big-endian bugs which could cause fs corruptions
Date: Thu, 04 Apr 2013 00:48:38 +0800
Message-ID: <515C5D66.9000606@gmail.com>
References: <1365007002-17528-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christian Kujau <lists@nerdbynature.de>,
	CAI Qian <caiqian@redhat.com>, sbest@redhat.com,
	Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40846 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561Ab3DCQsq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 12:48:46 -0400
In-Reply-To: <1365007002-17528-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/04/2013 12:36 AM, Theodore Ts'o wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When an extent was zeroed out, we forgot to do convert from cpu to le16.
> It could make us hit a BUG_ON when we try to write dirty pages out.  So
> fix it.
> 
> [ Also fix a bug found by Dmitry Monakhov where we were missing
>   le32_to_cpu() calls in the new indirect punch hole code.
> 
>   There are a number of other big endian warnings found by static code
>   analyzers, but we'll wait for the next merge window to fix them all
>   up.  These fixes are designed to be Obviously Correct by code
>   inspection, and easy to demonstrate that it won't make any
>   difference (and hence, won't introduce any bugs) on little endian
>   architectures such as x86.  --tytso ]
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reported-by: CAI Qian <caiqian@redhat.com>
> Reported-by: Christian Kujau <lists@nerdbynature.de>
> Cc: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good to me.

Thanks,
						- Zheng

> ---
> 
> This is what I plan to be sending to Linus very shortly.  If anyone
> could  test / review this patch ASAP, I'd really appreciate it, thanks!!
> 
>  fs/ext4/extents.c  | 11 +++++++----
>  fs/ext4/indirect.c |  4 ++--
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 56efcaa..9c6d06d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2999,20 +2999,23 @@ static int ext4_split_extent_at(handle_t *handle,
>  			if (split_flag & EXT4_EXT_DATA_VALID1) {
>  				err = ext4_ext_zeroout(inode, ex2);
>  				zero_ex.ee_block = ex2->ee_block;
> -				zero_ex.ee_len = ext4_ext_get_actual_len(ex2);
> +				zero_ex.ee_len = cpu_to_le16(
> +						ext4_ext_get_actual_len(ex2));
>  				ext4_ext_store_pblock(&zero_ex,
>  						      ext4_ext_pblock(ex2));
>  			} else {
>  				err = ext4_ext_zeroout(inode, ex);
>  				zero_ex.ee_block = ex->ee_block;
> -				zero_ex.ee_len = ext4_ext_get_actual_len(ex);
> +				zero_ex.ee_len = cpu_to_le16(
> +						ext4_ext_get_actual_len(ex));
>  				ext4_ext_store_pblock(&zero_ex,
>  						      ext4_ext_pblock(ex));
>  			}
>  		} else {
>  			err = ext4_ext_zeroout(inode, &orig_ex);
>  			zero_ex.ee_block = orig_ex.ee_block;
> -			zero_ex.ee_len = ext4_ext_get_actual_len(&orig_ex);
> +			zero_ex.ee_len = cpu_to_le16(
> +						ext4_ext_get_actual_len(&orig_ex));
>  			ext4_ext_store_pblock(&zero_ex,
>  					      ext4_ext_pblock(&orig_ex));
>  		}
> @@ -3272,7 +3275,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		if (err)
>  			goto out;
>  		zero_ex.ee_block = ex->ee_block;
> -		zero_ex.ee_len = ext4_ext_get_actual_len(ex);
> +		zero_ex.ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex));
>  		ext4_ext_store_pblock(&zero_ex, ext4_ext_pblock(ex));
>  
>  		err = ext4_ext_get_access(handle, inode, path + depth);
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index b505a14..a041831 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -1539,9 +1539,9 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
>  		blk = *i_data;
>  		if (level > 0) {
>  			ext4_lblk_t first2;
> -			bh = sb_bread(inode->i_sb, blk);
> +			bh = sb_bread(inode->i_sb, le32_to_cpu(blk));
>  			if (!bh) {
> -				EXT4_ERROR_INODE_BLOCK(inode, blk,
> +				EXT4_ERROR_INODE_BLOCK(inode, le32_to_cpu(blk),
>  						       "Read failure");
>  				return -EIO;
>  			}
> 

