From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 26/31] libext2fs: openfs() musn't allow bigalloc without
 EXT2_FLAGS_64BITS
Date: Mon, 7 Oct 2013 14:50:52 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310071450260.1975@localhost.localdomain>
References: <20131001012642.28415.89353.stgit@birch.djwong.org> <20131001012928.28415.62086.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab3JGMvA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 08:51:00 -0400
In-Reply-To: <20131001012928.28415.62086.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Sep 2013, Darrick J. Wong wrote:

> Date: Mon, 30 Sep 2013 18:29:28 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 26/31] libext2fs: openfs() musn't allow bigalloc without
>     EXT2_FLAGS_64BITS
> 
> Currently, only the 64-bit bitmap implementation supports the block<->cluster
> conversions that bigalloc requires.  Therefore, if we have a bigalloc
> filesystem, require EXT2_FLAGS_64BITS be passed in to ext2fs_open().
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/openfs.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> 
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 3c0bf14..f486a35 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -272,6 +272,18 @@ errcode_t ext2fs_open3(const char *name, const char *io_options,
>  		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
>  		goto cleanup;
>  	}
> +
> +	/*
> +	 * bigalloc requires cluster-aware bitfield operations, which at the
> +	 * moment means we need EXT2_FLAG_64BITS.
> +	 */
> +	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +				       EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
> +	    !(flags & EXT2_FLAG_64BITS)) {
> +		retval = EXT2_ET_CANT_USE_LEGACY_BITMAPS;
> +		goto cleanup;
> +	}
> +
>  	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
>  					EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
>  	    (fs->super->s_log_block_size != fs->super->s_log_cluster_size)) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
