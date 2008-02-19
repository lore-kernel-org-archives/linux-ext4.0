From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 3/4] ext4: use ext4_get_group_desc()
Date: Tue, 19 Feb 2008 00:19:07 -0800
Message-ID: <1203409147.3612.31.camel@localhost.localdomain>
References: <20080217061352.GJ3390@APFDCB5C>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Theodore Tso <tytso@MIT.EDU>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:55792 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYBSITR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 03:19:17 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J8JBeJ010477
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:19:11 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J8JBFu213810
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 01:19:11 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J8JAlb014729
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 01:19:11 -0700
In-Reply-To: <20080217061352.GJ3390@APFDCB5C>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2008-02-17 at 15:13 +0900, Akinobu Mita wrote:
> Use ext4_get_group_desc()
> 
Acked and added to ext4 patch queue.

> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Stephen Tweedie <sct@redhat.com>
> Cc: adilger@clusterfs.com
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: Theodore Tso <tytso@MIT.EDU>
> ---
>  fs/ext4/inode.c |   20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
> 
> Index: 2.6-rc/fs/ext4/inode.c
> ===================================================================
> --- 2.6-rc.orig/fs/ext4/inode.c
> +++ 2.6-rc/fs/ext4/inode.c
> @@ -2455,12 +2455,10 @@ out_stop:
>  static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
>  		unsigned long ino, struct ext4_iloc *iloc)
>  {
> -	unsigned long desc, group_desc;
>  	ext4_group_t block_group;
>  	unsigned long offset;
>  	ext4_fsblk_t block;
> -	struct buffer_head *bh;
> -	struct ext4_group_desc * gdp;
> +	struct ext4_group_desc *gdp;
> 
>  	if (!ext4_valid_inum(sb, ino)) {
>  		/*
> @@ -2472,22 +2470,10 @@ static ext4_fsblk_t ext4_get_inode_block
>  	}
> 
>  	block_group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
> -	if (block_group >= EXT4_SB(sb)->s_groups_count) {
> -		ext4_error(sb,"ext4_get_inode_block","group >= groups count");
> +	gdp = ext4_get_group_desc(sb, block_group, NULL);
> +	if (!gdp)
>  		return 0;
> -	}
> -	smp_rmb();
> -	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
> -	desc = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
> -	bh = EXT4_SB(sb)->s_group_desc[group_desc];
> -	if (!bh) {
> -		ext4_error (sb, "ext4_get_inode_block",
> -			    "Descriptor not loaded");
> -		return 0;
> -	}
> 
> -	gdp = (struct ext4_group_desc *)((__u8 *)bh->b_data +
> -		desc * EXT4_DESC_SIZE(sb));
>  	/*
>  	 * Figure out the offset within the block group inode table
>  	 */
