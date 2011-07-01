From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/4] ext4: fix trim length underflow with small trim
 length.
Date: Fri, 1 Jul 2011 11:45:17 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1107011140400.4168@dhcp-27-109.brq.redhat.com>
References: <4E0C8B6C.8030403@tao.ma> <1309445439-3753-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab1GAJpX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jul 2011 05:45:23 -0400
In-Reply-To: <1309445439-3753-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 30 Jun 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> In 0f0a25b, we adjust 'len' with s_first_data_block - start, but
> it could underflow in case blocksize=1K, fstrim_range.len=512 and
> fstrim_range.start = 0. In this case, when we run the code:
> len -= first_data_blk - start; len will be underflow to -1ULL.
> In the end, although we are safe that last_group check later will limit
> the trim to the whole volume, but that isn't what the user really want.
> 
> So this patch fix it. It also adds the check for 'start' like ext3 so that
> we can break immediately if the start is invalid.

Hi Tao,

thanks for the resend!

> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/mballoc.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 6ed859d..2336424 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4904,6 +4904,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  
>  	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
>  		return -EINVAL;
> +	if (start >= ext4_blocks_count(EXT4_SB(sb)->s_es) ||
> +	    start + len <= first_data_blk)
> +		goto out;

We should really return -EINVAL in case that start is beyond the
filesystem. However we can not return -EINVAL in case that start+len is
before the first data block, because it would require user to know fs
internals.

So simply doing this, should be enough:

	if (start + len <= first_data_blk)
		goto out;

and the code later

	if (first_group > last_group)
		return -EINVAL;

will handle the rest.

Thanks!
-Lukas


>  	if (start < first_data_blk) {
>  		len -= first_data_blk - start;
>  		start = first_data_blk;
> @@ -4952,5 +4955,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	}
>  	range->len = trimmed * sb->s_blocksize;
>  
> +out:
>  	return ret;
>  }
> 

-- 
