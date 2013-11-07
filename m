From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix reading of extended tv_sec (bug 23732)
Date: Thu, 7 Nov 2013 17:03:41 +0100
Message-ID: <20131107160341.GA3850@quack.suse.cz>
References: <1383808590.23882.13.camel@chiang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>
To: David Turner <novalis@novalis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab3KGQDo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Nov 2013 11:03:44 -0500
Content-Disposition: inline
In-Reply-To: <1383808590.23882.13.camel@chiang>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-11-13 02:16:30, David Turner wrote:
> In ext4, the bottom two bits of {a,c,m}time_extra are used to extend
> the {a,c,m}time fields, deferring the year 2038 problem to the year
> 2446.  The representation (which this patch does not alter) is a bit
> hackish, in that the most-significant bit is no longer (alone)
> sufficient to indicate the sign.  That's because we're representing an
> asymmetric range, with seven times as many positive values as
> negative.
> 
> When decoding these extended fields, for times whose bottom 32 bits
> would represent a negative number, sign extension causes the 64-bit
> extended timestamp to be negative as well, which is not what's
> intended.  This patch corrects that issue, so that the only negative
> {a,c,m}times are those between 1901 and 1970 (as per 32-bit signed
> timestamps).
> 
> Signed-off-by: David Turner <novalis@novalis.org>
> Reported-by: Mark Harris <mh8928@yahoo.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=23732
> ---
>  fs/ext4/ext4.h | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index af815ea..7b73c26 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -722,10 +722,15 @@ static inline __le32 ext4_encode_extra_time(struct timespec *time)
>  
>  static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
>  {
> -       if (sizeof(time->tv_sec) > 4)
> -	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
> -			       << 32;
> -       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
> +	if (sizeof(time->tv_sec) > 4) {
> +		u64 extra_bits = (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK);
  The extra cast to (__u64) looks useless here.

> +		if (time->tv_sec > 0 || extra_bits != EXT4_EPOCH_MASK) {
> +			time->tv_sec &= 0xFFFFFFFF;
> +			time->tv_sec |= extra_bits << 32;
> +		}
> +		time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >>
> +			EXT4_EPOCH_BITS;
> +	}
>  }
  So I'm somewhat wondering: Previously we decoded tv_nsec regardless of
tv_sec size. After your patch we do it only if sizeof(time->tv_sec) > 4. Is
this an intended change? Why is it OK?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
