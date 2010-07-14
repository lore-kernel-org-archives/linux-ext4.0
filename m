From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mballoc: allocate stripe-multiple IOs on stripe boundaries
Date: Wed, 14 Jul 2010 15:33:30 -0600
Message-ID: <9AD9AE85-D989-4E74-A330-B1D223A89F56@dilger.ca>
References: <4C3E27BF.2000005@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:45524 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0GNVdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jul 2010 17:33:32 -0400
In-Reply-To: <4C3E27BF.2000005@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ah, good catch.  We don't notice this on Lustre, since we always use at most 1MB writes from the network and always configure with 1MB stripe size.

On 2010-07-14, at 15:10, Eric Sandeen wrote:
> For some reason, today mballoc only allocates IOs which are exactly
> stripe-sized on a stripe boundary.  If you have a multiple (say, a
> 128k IO on a 64k stripe) you may end up unaligned.
> 
> It seems to me that a simple change to align stripe-multiple IOs
> on stripe boundaries would be a very good idea, unless this breaks
> some other mballoc heuristic for some reason...
> 
> Reported-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 12b3bc0..f64a439 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1821,8 +1821,7 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
> 
> /*
> * This is a special case for storages like raid5
> - * we try to find stripe-aligned chunks for stripe-size requests
> - * XXX should do so at least for multiples of stripe size as well
> + * we try to find stripe-aligned chunks for stripe-size-multiple requests
> */
> static noinline_for_stack
> void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
> @@ -2094,8 +2093,8 @@ repeat:
> 			ac->ac_groups_scanned++;
> 			if (cr == 0)
> 				ext4_mb_simple_scan_group(ac, &e4b);
> -			else if (cr == 1 &&
> -					ac->ac_g_ex.fe_len == sbi->s_stripe)
> +			else if (cr == 1 && sbi->s_stripe &&
> +					!(ac->ac_g_ex.fe_len % sbi->s_stripe))
> 				ext4_mb_scan_aligned(ac, &e4b);
> 			else
> 				ext4_mb_complex_scan_group(ac, &e4b);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





