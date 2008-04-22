From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [E2FSPROGS, RFC] Basic flexible block group support
Date: Tue, 22 Apr 2008 08:47:32 -0500
Message-ID: <20080422084732.3e4ad0b9@gara>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
	<1208868379-17580-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Valerie Clement <valerie.clement@bull.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:47891 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715AbYDVNrk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 09:47:40 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3MDldOl006072
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 09:47:39 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3MDla81083866
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 07:47:38 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3MDlZcM005380
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 07:47:35 -0600
In-Reply-To: <1208868379-17580-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Apr 2008 08:46:18 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> Add superblock definition, and dumpe2fs and debugfs support.

Looks good.
 
> Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> Signed-off-by: Valerie Clement <valerie.clement@bull.net>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  debugfs/set_fields.c |    1 +
>  lib/e2p/ls.c         |    3 +++
>  lib/ext2fs/ext2_fs.h |    5 ++++-
>  3 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index ee51c45..25343f0 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -132,6 +132,7 @@ static struct field_set_info super_fields[] = {
>  	{ "mmp_interval", &set_sb.s_mmp_interval, 2, parse_uint },
>  	{ "mmp_block", &set_sb.s_mmp_block, 8, parse_uint },
>  	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, 4, parse_uint },
> +	{ "log_groups_per_flex", &set_sb.s_log_groups_per_flex, 1, parse_uint },
>  	{ 0, 0, 0, 0 }
>  };
> 
> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
> index b119606..c211dce 100644
> --- a/lib/e2p/ls.c
> +++ b/lib/e2p/ls.c
> @@ -242,6 +242,9 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
>  	if (sb->s_first_meta_bg)
>  		fprintf(f, "First meta block group:   %u\n",
>  			sb->s_first_meta_bg);
> +	if (sb->s_log_groups_per_flex)
> +		fprintf(f, "Flex block group size:    %u\n",
> +			1 << sb->s_log_groups_per_flex);
>  	if (sb->s_mkfs_time) {
>  		tm = sb->s_mkfs_time;
>  		fprintf(f, "Filesystem created:       %s", ctime(&tm));
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index ad42cf8..f23c8fd 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -564,7 +564,10 @@ struct ext2_super_block {
>  	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
>  	__u64   s_mmp_block;            /* Block for multi-mount protection */
>  	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
> -	__u32   s_reserved[163];        /* Padding to the end of the block */
> +	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
> +	__u8    s_reserved_char_pad;
> +	__u16	s_reserved_pad;		/* Padding to next 32bits */
> +	__u32   s_reserved[162];        /* Padding to the end of the block */
>  };
> 
>  /*



-JRS
