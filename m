From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Add batched discard support for ext3
Date: Mon, 12 Jul 2010 17:28:25 +0200
Message-ID: <20100712152825.GB19433@atrey.karlin.mff.cuni.cz>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <1278508727-29135-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54610 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751397Ab0GLP20 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 11:28:26 -0400
Content-Disposition: inline
In-Reply-To: <1278508727-29135-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Walk through each allocation group and trim all free extents. It can be
> invoked through TRIM ioctl on the file system. The main idea is to
> provide a way to trim the whole file system if needed, since some SSD's
> may suffer from performance loss after the whole device was filled (it
> does not mean that fs is full!).
> 
> It search for free extents in each allocation group. When the free
> extent is found, blocks are marked as used and then trimmed. Afterwards
> these blocks are marked as free in per-group bitmap.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext3/balloc.c        |  145 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext3/super.c         |    1 +
>  include/linux/ext3_fs.h |    1 +
>  3 files changed, 147 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index a177122..bcee525 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
...
> +		/**
> +		 * Allocate contiguous free extents by setting bits in the
> +		 * block bitmap
> +		 */
> +		while (next < max
> +			&& !ext3_set_bit_atomic(sb_bgl_lock(sbi, group),
> +					next, bh->b_data)) {
> +			next++;
> +		}
  This is actually wrong. You completely ignore journalling here. You can't
just go and modify metadata buffer - other process can be modifying it as well
and writing it to disk and thus your changes will also get written. And if
a crash happens afterwards before the bitmap is written again, you'll get an
inconsistent filesystem.
  Also you have to check whether the block isn't actually still used by a
running/committing transaction - look at fs/ext3/balloc.c:claim_block() to see
how you have to allocate free blocks.
  All-in-all won't it be good enough to just freeze the fs, do the trimming,
and unfreeze it?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
