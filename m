From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] ext4: use timespec64 for all inode times
Date: Fri, 22 Jun 2018 09:37:28 +0200
Message-ID: <20180622073728.76imgamp3u4ivhf3@quack2.suse.cz>
References: <20180620153322.54221-1-arnd@arndb.de>
 <20180620153322.54221-4-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, y2038@lists.linaro.org,
        linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620153322.54221-4-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 20-06-18 17:33:01, Arnd Bergmann wrote:
> -static inline __le32 ext4_encode_extra_time(struct timespec *time)
> +static inline __le32 ext4_encode_extra_time(struct timespec64 *time)
>  {
>  	u32 extra = sizeof(time->tv_sec) > 4 ?

I suppose this condition can be removed now.

>  		((time->tv_sec - (s32)time->tv_sec) >> 32) & EXT4_EPOCH_MASK : 0;
>  	return cpu_to_le32(extra | (time->tv_nsec << EXT4_EPOCH_BITS));
>  }
>  
> -static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
> +static inline void ext4_decode_extra_time(struct timespec64 *time, __le32 extra)

Wrap?

Otherwise the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
