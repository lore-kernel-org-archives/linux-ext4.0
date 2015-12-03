From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] filefrag: accommodate holes when calculating expected
 values
Date: Thu, 3 Dec 2015 12:30:38 -0800
Message-ID: <20151203203038.GG10580@birch.djwong.org>
References: <20151201000310.GF10580@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41421 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbbLCUaq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Dec 2015 15:30:46 -0500
Content-Disposition: inline
In-Reply-To: <20151201000310.GF10580@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

NAK, this patch doesn't handle extents that cross multiple FIEMAP calls.

Digging further, the fibmap version prints some rather borken results,
so I might as well fix both issues for v2.

--D

On Mon, Nov 30, 2015 at 04:03:10PM -0800, Darrick J. Wong wrote:
> Currently, filefrag's "expected physical block" column expects extent
> records to be physically adjacent regardless of the amount of logical
> block space between the two records.  This means that if we punch a
> hole in a file, we get reports like this:
> 
> 4:     4096..    8343:   57376..  61623:   4248:   55328:
> 5:     8345..   10313:   61625..  63593:   1969:   61624:
> 
> Notice how it expects 8345 to map to 61624, and scores this against
> the fragmentation of the file.  Flagging this as "unexpected" is
> incorrect because the gap in the logical mapping is exactly the same
> size as the gap in the physical extents.
> 
> Furthermore, this scenario leaves the door open to the optimal mapping
> -- if a write to block 8344 causes it to be mapped to 61624, the
> entire range 4096-10313 can be mapped with a single extent.  Until
> that happens, there's no way to combine extents 4 and 5 because of the
> gap in the logical mapping at block 8344.
> 
> Therefore, tweak the extent report to account for holes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/filefrag.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index 5bcde91..dacdae6 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -266,7 +266,12 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents,
>  				print_extent_info(&fm_ext[i], n, expected,
>  						  blk_shift, st);
>  
> -			expected = fm_ext[i].fe_physical + fm_ext[i].fe_length;
> +			expected = fm_ext[i].fe_physical;
> +			if (i < fiemap->fm_mapped_extents - 1)
> +				expected += fm_ext[i + 1].fe_logical -
> +						fm_ext[i].fe_logical;
> +			else
> +				expected += fm_ext[i].fe_length;
>  			if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
>  				last = 1;
>  			n++;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
