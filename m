From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix trim length underflow with small trim
 length.
Date: Wed, 19 Jan 2011 12:05:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101191204300.2686@dhcp-lab-213.englab.brq.redhat.com>
References: <1295430358-8912-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab1ASLFw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jan 2011 06:05:52 -0500
In-Reply-To: <1295430358-8912-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 19 Jan 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> In 0f0a25b, we adjust 'len' with s_first_data_block - start, but it could
> underflow in case blocksize=1K, while fstrim_range.len=512 and
> fstrim_range.start = 0. In this case len happens to be underflow and in
> the end, although we are safe that last_group check will limit the trim
> to the whole volume, I am afraid that isn't what the user really want.
> 
> So this patch fix it. It also adds the check for 'start' like ext3 so that
> we can break immediately if the start is invalid.

I have the same objection as in case of ext3. Here is a copy-paste:

Well, I just realized that what are we doing is not exactly what will
user expect. User does not really care where the first data block is.
What the user will expect is, to trim let's say first one gigabyte
of his filesystem, not gigabyte - first data block.

So what I suggest is to always add first_data_block to
fstrim_range.start and do all the necessary checks for overflow. If no
one has any objections I'll put it to the patch.

Thanks!
-Lukas


> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/mballoc.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 851f49b..397db8d 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4819,6 +4819,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  
>  	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
>  		return -EINVAL;
> +	if (start >= ext4_blocks_count(EXT4_SB(sb)->s_es) ||
> +	    start + len <= first_data_blk)
> +		goto out;
>  	if (start < first_data_blk) {
>  		len -= first_data_blk - start;
>  		start = first_data_blk;
> @@ -4863,5 +4866,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	}
>  	range->len = trimmed * sb->s_blocksize;
>  
> +out:
>  	return ret;
>  }
> 
