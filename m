From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 2/7]ext4: Add EXT4_IOC_CLR_GLOBAL_ALLOC_RULE	clears
 block allocation restriction
Date: Wed, 24 Jun 2009 17:20:15 +0900
Message-ID: <4A41E1BF.3090805@rs.jp.nec.com>
References: <4A409171.3090202@rs.jp.nec.com> <20090623232131.GO31668@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090623232131.GO31668@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Andreas,

Andreas Dilger wrote:
> On Jun 23, 2009  17:25 +0900, Akira Fujita wrote:
>> Block allocation restriction is cleared with this ioctl or umount filesystem.
>>
>>  #define EXT4_IOC_CLR_GLOBAL_ALLOC_RULE _IOW('f', 17, struct ext4_alloc_rule);
>>
>>   struct ext4_alloc_rule {
>>         __u64 start;            /* start physical offset to clear rule */
>>         __u64 len;              /* number of blocks to be clear */
>>         __u32 alloc_flag;       /* not used, should be zero */
>>   };
> 
> Why not call EXT4_IOC_ADD_GLOBAL_ALLOC_RULE with a "clear" flag?

Yes, having "clear" flag makes more sense
than implementing ioctls separately.

I will add "clear" flag (EXT4_MB_CLEAR_ALLOC_RULE) to alloc_flag
and remove EXT4_IOC_CLR_GLOBAL_ALLOC_RULE ioctl in the next version.

Thanks,
Akira Fujita
