From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix trimming starting with block 0 with small
 blocksize
Date: Tue, 11 Jan 2011 11:40:49 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101111138400.3095@dhcp-lab-213.englab.brq.redhat.com>
References: <1294682433-6775-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab1AKKlA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Jan 2011 05:41:00 -0500
In-Reply-To: <1294682433-6775-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 10 Jan 2011, Jan Kara wrote:

> When s_first_data_block is not zero (which happens e.g. when block size is 1KB)
> and trim ioctl is called to start trimming from block 0, the math in
> ext4_get_group_no_and_offset() overflows. The overall result is that ioctl
> returns EINVAL which is kind of unexpected and we probably don't want
> userspace tools to bother with internal details of filesystem structure.
> So just silently increase starting offset (and shorten length) when starting
> block is below s_first_data_block.
> 
> CC: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/mballoc.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 4c4766c..b9c2aad 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4819,6 +4819,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  	ext4_group_t group, ngroups = ext4_get_groups_count(sb);
>  	ext4_grpblk_t cnt = 0, first_block, last_block;
>  	uint64_t start, len, minlen, trimmed;
> +	ext4_fsblk_t first_data_blk =
> +			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
>  	int ret = 0;
>  
>  	start = range->start >> sb->s_blocksize_bits;
> @@ -4828,6 +4830,10 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  
>  	if (unlikely(minlen > EXT4_BLOCKS_PER_GROUP(sb)))
>  		return -EINVAL;
> +	if (start < first_data_blk) {
> +		len -= first_data_blk - start;
> +		start = first_data_blk;
> +	}
>  
>  	/* Determine first and last group to examine based on start and len */
>  	ext4_get_group_no_and_offset(sb, (ext4_fsblk_t) start,
> 

Hi Ted,

forget my previous patch, this is the right one. Thanks Jan!

-Lukas
