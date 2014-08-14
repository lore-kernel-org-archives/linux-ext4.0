From: Chin-Tzung Cheng <chintzung@gmail.com>
Subject: Re: [PATCH] ext4: include journal blocks of internal journal in df
 overhead calcs
Date: Thu, 14 Aug 2014 14:56:26 +0800
Message-ID: <CAPBYzXO88Q_Du7_ssoesKoggQF=U5qVTp-7M4eBOfT_rBRDWJA@mail.gmail.com>
References: <1407937043-23186-1-git-send-email-chintzung@gmail.com>
	<53EC2B1C.1090806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53EC2B1C.1090806@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2014-08-14 11:21 GMT+08:00 Eric Sandeen <sandeen@redhat.com>:
> On 8/13/14, 6:37 AM, Chin-Tsung Cheng wrote:
>> The journal blocks of external journal device should not
>> be counted as overhead.
>>
>> Signed-off-by: Chin-Tsung Cheng <chintzung@gmail.com>
>
> Yep, I added this and didn't consider external journals, oops.
>
> Agree with Darrick that whitespace (and parens) aren't ideal...
>
 OK. I will fix it.
> Is this a shorter test?
>
>         if (sbi->s_journal && !sbi->journal_bdev) {
>                 overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
>
>
> *sbi gets kzalloced and I *think* journal_bdev is only filled in for
> external journals...

 Yes, journal_bdev is only filled in ext4_get_dev_journal() function
 for external journal device.
>
> ext3_statfs probably needs the same treatment, it unconditionally does:
>
>
>                 /* Add the journal blocks as well */
>                 overhead += sbi->s_journal->j_maxlen;
>
 Yes, it also miscalculates the number of file system overhead blocks
for  external journal device. This causes the f_blocks field in the
statfs
 structure to be smaller than it should be.

 This would cause the "df" output to show the number of data blocks in
the file  system smaller than they should be, and the number of used
blocks might be  negative.

> -Eric
>
>> ---
>>  fs/ext4/super.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 32b43ad..03b2f62 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3316,9 +3316,10 @@ int ext4_calculate_overhead(struct super_block *sb)
>>                       memset(buf, 0, PAGE_SIZE);
>>               cond_resched();
>>       }
>> -     /* Add the journal blocks as well */
>> -     if (sbi->s_journal)
>> -             overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
>> +     /* Add the internal journal blocks as well */
>> +     if ((sbi->s_journal) &&
>> +             (sbi->s_journal->j_fs_dev == sbi->s_journal->j_dev))
>> +                     overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
>>
>>       sbi->s_overhead = overhead;
>>       smp_wmb();
>>
>
