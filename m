From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 1/2] ext4: Fix handling of extended tv_sec (bug 23732)
Date: Wed, 13 Nov 2013 00:19:40 -0800
Message-ID: <20131113081940.GB10269@birch.djwong.org>
References: <1383864864.23882.33.camel@chiang>
 <20131107231445.GG2054@quack.suse.cz>
 <1383866807.23882.41.camel@chiang>
 <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
 <1383981551.8994.27.camel@chiang>
 <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com>
 <1384070214.8994.47.camel@chiang>
 <20131112003018.GA30281@thunk.org>
 <6DE0AF86-98E6-4DE9-BB7F-40FB32E1BC26@dilger.ca>
 <1384326015.8994.185.camel@chiang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Mark Harris <mhlk@osj.us>,
	Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: David Turner <novalis@novalis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab3KMITw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Nov 2013 03:19:52 -0500
Content-Disposition: inline
In-Reply-To: <1384326015.8994.185.camel@chiang>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 13, 2013 at 02:00:15AM -0500, David Turner wrote:
> In ext4, the bottom two bits of {a,c,m}time_extra are used to extend
> the {a,c,m}time fields, deferring the year 2038 problem to the year
> 2446.
> 
> When decoding these extended fields, for times whose bottom 32 bits
> would represent a negative number, sign extension causes the 64-bit
> extended timestamp to be negative as well, which is not what's
> intended.  This patch corrects that issue, so that the only negative
> {a,c,m}times are those between 1901 and 1970 (as per 32-bit signed
> timestamps).
> 
> Some older kernels might have written pre-1970 dates with 1,1 in the
> extra bits.  This patch treats those incorrectly-encoded dates as
> pre-1970, instead of post-2311, until kernel 4.20 is released.
> Hopefully by then e2fsck will have fixed up the bad data.
> 
> Signed-off-by: David Turner <novalis@novalis.org>
> Reported-by: Mark Harris <mh8928@yahoo.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=23732
> ---
>  fs/ext4/ext4.h | 61 +++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 39 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 18aa56b..7d5e019 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -26,6 +26,7 @@
>  #include <linux/seqlock.h>
>  #include <linux/mutex.h>
>  #include <linux/timer.h>
> +#include <linux/version.h>
>  #include <linux/wait.h>
>  #include <linux/blockgroup_lock.h>
>  #include <linux/percpu_counter.h>
> @@ -713,38 +714,54 @@ struct move_extent {
>  	  sizeof((ext4_inode)->field))			\
>  	<= (EXT4_GOOD_OLD_INODE_SIZE +			\
>  	    (einode)->i_extra_isize))			\
> +
>  /*
> - * We use the bottom 34 bits of the signed 64-bit time value, with
> - * the top two of these bits in the bottom of extra.  This leads
> - * to a slightly odd encoding, which works like this:
> + * We need is an encoding that preserves the times for extra epoch "00":
>   *
> - * extra  msb of
> - * epoch  32-bit
> - * bits   time    decoded 64-bit tv_sec   valid time range
> - * 0 0    0    0x000000000..0x07fffffff  1970-01-01..2038-01-19
> - * 0 0    1    0x080000000..0x0ffffffff  2038-01-19..2106-02-07
> - * 0 1    0    0x100000000..0x17fffffff  2106-02-07..2174-02-25
> - * 0 1    1    0x180000000..0x1ffffffff  2174-02-25..2242-03-16
> - * 1 0    0    0x200000000..0x27fffffff  2242-03-16..2310-04-04
> - * 1 0    1    0x280000000..0x2ffffffff  2310-04-04..2378-04-22
> - * 1 1    0    0x300000000..0x37fffffff  2378-04-22..2446-05-10
> -
> - * 1 1    1    -0x80000000..-0x00000001  1901-12-13..1969-12-31
> + * extra  msb of                         adjust for signed
> + * epoch  32-bit                         32-bit tv_sec to
> + * bits   time    decoded 64-bit tv_sec  64-bit tv_sec      valid time range
> + * 0 0    1    -0x80000000..-0x00000001  0x000000000     1901-12-13..1969-12-31
> + * 0 0    0    0x000000000..0x07fffffff  0x000000000     1970-01-01..2038-01-19
> + * 0 1    1    0x080000000..0x0ffffffff  0x100000000     2038-01-19..2106-02-07
> + * 0 1    0    0x100000000..0x17fffffff  0x100000000     2106-02-07..2174-02-25
> + * 1 0    1    0x180000000..0x1ffffffff  0x200000000     2174-02-25..2242-03-16
> + * 1 0    0    0x200000000..0x27fffffff  0x200000000     2242-03-16..2310-04-04
> + * 1 1    1    0x280000000..0x2ffffffff  0x300000000     2310-04-04..2378-04-22
> + * 1 1    0    0x300000000..0x37fffffff  0x300000000     2378-04-22..2446-05-10
> + *
> + * Note that previous versions of the kernel on 64-bit systems would
> + * incorrectly use extra epoch bits 1,1 for dates between 1901 and
> + * 1970.  e2fsck will correct this, assuming that it is run on the
> + * affected filesystem before 2311.

Given the table, should this be "before 2310-04-04"?

--D
>   */
>  
>  static inline __le32 ext4_encode_extra_time(struct timespec *time)
>  {
> -       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
> -			   (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
> -                          ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
> +	u32 extra = sizeof(time->tv_sec) > 4 ?
> +		((time->tv_sec - (s32)time->tv_sec) >> 32) & EXT4_EPOCH_MASK : 0;
> +	return cpu_to_le32(extra | (time->tv_nsec << EXT4_EPOCH_BITS));
>  }
>  
>  static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
>  {
> -       if (sizeof(time->tv_sec) > 4)
> -	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
> -			       << 32;
> -       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
> +	if (unlikely(sizeof(time->tv_sec) > 4 &&
> +			(extra & cpu_to_le32(EXT4_EPOCH_MASK)))) {
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
> +		/* Handle legacy encoding of pre-1970 dates with epoch
> +		 * bits 1,1.  We assume that by kernel version 4.20,
> +		 * everyone will have run fsck over the affected
> +		 * filesystems to correct the problem.
> +		 */
> +		u64 extra_bits = le32_to_cpu(extra) & EXT4_EPOCH_MASK;
> +		if (extra_bits == 3)
> +			extra_bits = 0;
> +		time->tv_sec += extra_bits << 32;
> +#else
> +		time->tv_sec += (u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;
> +#endif
> +	}
> +	time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
>  }
>  
>  #define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \
> -- 
> 1.8.1.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
