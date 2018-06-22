From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 4/6] ext4: use timespec64 for all inode times
Date: Fri, 22 Jun 2018 10:15:16 +0200
Message-ID: <CAK8P3a2cjQugQYcqBN0RLhgG2kX+Pr0S=vWvWNFyFN7ruE-t+Q@mail.gmail.com>
References: <20180620153322.54221-1-arnd@arndb.de> <20180620153322.54221-4-arnd@arndb.de>
 <20180622073728.76imgamp3u4ivhf3@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622073728.76imgamp3u4ivhf3@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 22, 2018 at 9:37 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 20-06-18 17:33:01, Arnd Bergmann wrote:
>> -static inline __le32 ext4_encode_extra_time(struct timespec *time)
>> +static inline __le32 ext4_encode_extra_time(struct timespec64 *time)
>>  {
>>       u32 extra = sizeof(time->tv_sec) > 4 ?
>
> I suppose this condition can be removed now.

Right, good point. I also verified that we have no other similar
constructs in the kernel any more now.

>>               ((time->tv_sec - (s32)time->tv_sec) >> 32) & EXT4_EPOCH_MASK : 0;
>>       return cpu_to_le32(extra | (time->tv_nsec << EXT4_EPOCH_BITS));
>>  }
>>
>> -static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
>> +static inline void ext4_decode_extra_time(struct timespec64 *time, __le32 extra)
>
> Wrap?

Ok, done.

> Otherwise the patch looks good.

Thanks!

      Arnd
