From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] e2fsck: do not forget to discard last block group
Date: Mon, 12 Mar 2012 08:31:43 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203120830480.5543@dhcp-27-109.brq.redhat.com>
References: <20120311191836.GD1048@thunk.org> <1331494393-21577-1-git-send-email-tytso@mit.edu> <1331494393-21577-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	lczerner@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab2CLHbr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 03:31:47 -0400
In-Reply-To: <1331494393-21577-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 11 Mar 2012, Theodore Ts'o wrote:

> From: Lukas Czerner <lczerner@redhat.com>
> 
> Previously when running e2fsck with '-E discard' argument the end of
> the last group has not been discarded. This patch fixes it so we
> always discard the end of the last group if needed.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks good. Thanks for splitting the patch, it makes sense.

-Lukas

> ---
>  e2fsck/pass5.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index ca438cb..e25f080 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -387,6 +387,15 @@ redo_counts:
>  		if ((blocks == fs->super->s_clusters_per_group) ||
>  		    (EXT2FS_B2C(fs, i) ==
>  		     EXT2FS_B2C(fs, ext2fs_blocks_count(fs->super)-1))) {
> +			/*
> +			 * If the last block of this group is free, then we can
> +			 * discard it as well.
> +			 */
> +			if (!bitmap && i >= first_free)
> +				e2fsck_discard_blocks(ctx, first_free,
> +						      (i - first_free) + 1);
> +			first_free = ext2fs_blocks_count(fs->super);
> +
>  			free_array[group] = group_free;
>  			group ++;
>  			blocks = 0;
> 

-- 
