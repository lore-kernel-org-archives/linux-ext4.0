From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/1 linux-next] ext4: fix block_validity definition
Date: Sun, 23 Oct 2016 13:10:03 -0700
Message-ID: <20161023201003.GA5245@birch.djwong.org>
References: <1477251814-9938-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48733 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754595AbcJWUKL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2016 16:10:11 -0400
Content-Disposition: inline
In-Reply-To: <1477251814-9938-1-git-send-email-fabf@skynet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 23, 2016 at 09:43:34PM +0200, Fabian Frederick wrote:
> Fix ext4 documentation according to commit 45f1a9c3f63d
> ("ext4: enable block_validity by default")
> 
> Also fix some typos.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  Documentation/filesystems/ext4.txt | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index 6c0108e..024c6db 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -351,14 +351,13 @@ nouid32			Disables 32-bit UIDs and GIDs.  This is for
>  			interoperability  with  older kernels which only
>  			store and expect 16-bit values.
>  
> -block_validity		This options allows to enables/disables the in-kernel
> +block_validity(*)	This option allows to enable/disable the in-kernel

This sentence still reads awkwardly.  How about:

"These options enable or disable the in-kernel facility for tracking..."

The rest looks ok, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  noblock_validity	facility for tracking filesystem metadata blocks
>  			within internal data structures. This allows multi-
>  			block allocator and other routines to quickly locate
>  			extents which might overlap with filesystem metadata
> -			blocks. This option is intended for debugging
> -			purposes and since it negatively affects the
> -			performance, it is off by default.
> +			blocks. Initially intended for debugging, it's now
> +			enabled by default.
>  
>  dioread_lock		Controls whether or not ext4 should use the DIO read
>  dioread_nolock		locking. If the dioread_nolock option is specified
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
