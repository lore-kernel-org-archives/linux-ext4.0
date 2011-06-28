From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: quiet 'unused variables' compiling warnings
Date: Tue, 28 Jun 2011 11:33:53 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106281133370.3864@dhcp-27-109.brq.redhat.com>
References: <1309224525-23875-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab1F1JeA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 05:34:00 -0400
In-Reply-To: <1309224525-23875-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 28 Jun 2011, Yongqiang Yang wrote:

> Unused variables was deleted.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/extents.c |    2 --
>  fs/ext4/mballoc.c |    2 --
>  2 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f815cc8..94940aa 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3107,12 +3107,10 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
>  					      struct ext4_ext_path *path)
>  {
>  	struct ext4_extent *ex;
> -	struct ext4_extent_header *eh;
>  	int depth;
>  	int err = 0;
>  
>  	depth = ext_depth(inode);
> -	eh = path[depth].p_hdr;
>  	ex = path[depth].p_ext;
>  
>  	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 6ed859d..389386b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4666,12 +4666,10 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
>  	struct ext4_buddy e4b;
>  	int err = 0, ret, blk_free_count;
>  	ext4_grpblk_t blocks_freed;
> -	struct ext4_group_info *grp;
>  
>  	ext4_debug("Adding block(s) %llu-%llu\n", block, block + count - 1);
>  
>  	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
> -	grp = ext4_get_group_info(sb, block_group);
>  	/*
>  	 * Check to see if we are freeing blocks across a group
>  	 * boundary.
> 

Patch looks good. Thanks!
-Lukas
