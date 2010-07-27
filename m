From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] disallow FS recursion from sb_issue_discard allocation
Date: Tue, 27 Jul 2010 09:44:14 -0400
Message-ID: <20100727134414.GC18966@thunk.org>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
 <20100702181430.GD26916@redhat.com>
 <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021605410.13662@hs20-bc2-1.build.redhat.com>
 <20100706161155.GA24461@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jaxboe@fusionio.com>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100706161155.GA24461@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 06, 2010 at 12:11:56PM -0400, Mike Snitzer wrote:
> Filesystems can call sb_issue_discard on a memory reclaim path
> (e.g. ext4 calls sb_issue_discard during journal commit).
> 
> Use GFP_NOFS in sb_issue_discard to avoid recursing back into the FS.
> 
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Hi Jens,

I never saw an ack from you on this patch.  Are you ok with it, and
have you grabbed it for your tree?  Do you want me to include this in
the ext4 tree, even though it's a patch to include/linux/blkdev.h?

Thanks,

						- Ted


> ---
>  include/linux/blkdev.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index baf5258..dbb510c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -933,7 +933,7 @@ static inline int sb_issue_discard(struct super_block *sb,
>  {
>  	block <<= (sb->s_blocksize_bits - 9);
>  	nr_blocks <<= (sb->s_blocksize_bits - 9);
> -	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
> +	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_NOFS,
>  				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
