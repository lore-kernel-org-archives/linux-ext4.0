From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] fix up lazy_bg bitmap initialization at mkfs time
Date: Fri, 20 Apr 2007 16:19:18 -0600
Message-ID: <20070420221918.GT5967@schatzie.adilger.int>
References: <4627DA21.7050002@redhat.com> <20070420101020.GQ5967@schatzie.adilger.int> <4628D4CF.1020804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:44233 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766538AbXDTWTU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2007 18:19:20 -0400
Content-Disposition: inline
In-Reply-To: <4628D4CF.1020804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 20, 2007  09:57 -0500, Eric Sandeen wrote:
> Anyway, how about something like this for calculating journal size in 
> the face of lazy_bg.  I know the last group may be smaller... but I figure
> this is just a heuristic anyway.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Index: e2fsprogs-1.39_ext4_hg/misc/util.c
> ===================================================================
> --- e2fsprogs-1.39_ext4_hg.orig/misc/util.c
> +++ e2fsprogs-1.39_ext4_hg/misc/util.c
> @@ -252,8 +252,16 @@ void parse_journal_opts(const char *opts
>  int figure_journal_size(int size, ext2_filsys fs)
>  {
>  	blk_t j_blocks;
> +	blk_t fs_size;
>  
> -	if (fs->super->s_blocks_count < 2048) {
> +	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
> + 				    EXT2_FEATURE_COMPAT_LAZY_BG)) {
> +		fs_size = fs->super->s_blocks_per_group * 2; 
> +	} else {
> +		fs_size = fs->super->s_blocks_count;
> +	}

This should also check for !RO_COMPAT_UNINIT_GROUPS, since LAZY_BG
can be used in conjunction with UNINIT_GROUPS to mean "don't zero
uninitialized groups" but doesn't set bg_free_blocks_count == 0.

I was going to suggest using s_free_blocks_count, but that might
lead to confusion if e.g. e2fsck deletes a journal on a nearly-full
fs and then tune2fs recreates it much smaller than before.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
