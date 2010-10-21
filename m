From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] block: Make blkdev_issue_discard() interruptible
Date: Thu, 21 Oct 2010 12:52:22 -0400
Message-ID: <x49k4lb1oah.fsf@segfault.boston.devel.redhat.com>
References: <1287671673-11448-1-git-send-email-lczerner@redhat.com>
	<1287676486-19645-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
	adilger@dilger.ca, axboe@kernel.dk, linux-kernel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1287676486-19645-1-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Thu, 21 Oct 2010 17:54:46 +0200")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

> Since the discard may take quite long time, especially with really big
> extents (like the whole device for example), it would be nice to give to
> users the opportunity to abort it. This is especially useful for mkfs,
> when user can not know in advance how long it will take.
>
> In conjunction with mke2fs patch "Inform user about ongoing discard"
> it gives the user all the comfort of being informed about discard and
> being able to abort the operation.

For others reviewing, this is against the block tree's for-next branch.

> ---
>  block/blk-lib.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 1a320d2..db44671 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -91,6 +91,9 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		bio_get(bio);
>  		submit_bio(type, bio);
>  
> +		if (unlikely(fatal_signal_pending(current)))
> +			ret = -ERESTARTSYS;
> +
>  		wait_for_completion(&wait);
>  
>  		if (bio_flagged(bio, BIO_EOPNOTSUPP))

Given that you're still doing the wait_for_completion, wouldn't it be
better to check for a pending signal after that?

What testing did you perform?

Cheers,
Jeff
