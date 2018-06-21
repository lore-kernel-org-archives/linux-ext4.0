From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/6] [RFC] ext4: super: extend timestamps to 40 bits
Date: Thu, 21 Jun 2018 22:17:41 +0200
Message-ID: <CAK8P3a1X=hGS=tAec2uUFtRpLyw2J_nd58ookw0jePjd0mAdhA@mail.gmail.com>
References: <20180620153322.54221-1-arnd@arndb.de> <20180620153322.54221-6-arnd@arndb.de>
 <EA2C7036-ACD4-4E0A-80A1-373B000A7DA4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Tahsin Erdogan <tahsin@google.com>, Jan Kara <jack@suse.cz>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EA2C7036-ACD4-4E0A-80A1-373B000A7DA4@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 21, 2018 at 7:46 PM, Andreas Dilger <adilger@dilger.ca> wrote:

>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 0c4c2201b3aa..2063d4e5ed08 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -312,6 +312,20 @@ void ext4_itable_unused_set(struct super_block *sb,
>>               bg->bg_itable_unused_hi = cpu_to_le16(count >> 16);
>> }
>>
>> +static void ext4_update_tstamp(__le32 *lo, __u8 *hi)
>
> Would it be better to wrap this in a macro, something like:
>
> #define ext4_update_tstamp(es, tstamp) \
>         __ext4_update_tstamp(&(es)->tstamp, &(es)->tstamp ## _hi)
> #define ext4_get_tstamp(es, tstamp) \
>         __ext4_get_tstamp(&(es)->tstamp, &(es)->tstamp ## _hi)
>
> So that it can be used in the callers more easily:
>
>         ext4_update_tstamp(es, s_last_error_time);
>         time = ext4_get_tstamp(es, s_last_error_time);

I generally try to avoid concatenating identifiers like this, as it makes
it much harder to grep for where a particular symbol or
struct member gets used.

>> +{
>> +     time64_t now = ktime_get_real_seconds();
>> +
>> +     now = clamp_val(now, 0, 0xffffffffffull);
>
> Long strings of "0xfff..." are hard to get correct.  This looks right,
> but it may be easier to be sure it is correct with something like:
>
>         /* timestamps have a 32-bit low field and 8-bit high field */
>         now = clamp_val(now, 0, (1ULL << 40) - 1);

Yes, good idea. I'm surprised we don't have a generic macro for that yet
(or maybe I just couldn't find it)


>> @@ -249,6 +251,12 @@ static void *calc_ptr(struct ext4_attr *a, struct ext4_sb_info *sbi)
>>       return NULL;
>> }
>>
>> +static ssize_t print_time(char *buf, __le32 lo, __u8 hi)
>
> It would probably be more consistent to name this "print_tstamp()"
> since it isn't strictly a "time" as one would expect.

Ok.

>> +{
>> +     return snprintf(buf, PAGE_SIZE, "%lld",
>> +                     ((time64_t)hi << 32) + le32_to_cpu(lo));
>> +}
>
> Similarly, wrap this with:
>
> #define print_tstamp(buf, es, tstamp) \
>         __print_tstamp(buf, &(es)->tstamp, &(es)->tstamp ## _hi)

Ok. I'll integrate all of the above and post as a non-RFC patch then
after some testing.

      Arnd
