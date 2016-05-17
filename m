From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] ext4: add lazyinit stats support
Date: Tue, 17 May 2016 12:14:47 +0800
Message-ID: <CAP9B-Q=7BUzkODy_PAsWi3YT3pYBcqMDWPR6kR6pCqFMDa_tzA@mail.gmail.com>
References: <1463456488-93466-1-git-send-email-wangshilong1991@gmail.com>
	<e7de9f2f-6a12-026c-c9fb-2e676fdc37e4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca,
	Shuichi Ihara <sihara@ddn.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34799 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbcEQEOt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2016 00:14:49 -0400
Received: by mail-lf0-f68.google.com with SMTP id m101so248981lfi.1
        for <linux-ext4@vger.kernel.org>; Mon, 16 May 2016 21:14:48 -0700 (PDT)
In-Reply-To: <e7de9f2f-6a12-026c-c9fb-2e676fdc37e4@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2016 at 11:59 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 5/16/16 10:41 PM, Wang Shilong wrote:
>> From: Wang Shilong <wshilong@ddn.com>
>>
>> Somtimes, we need figure out progress of Lazyinit
>> in the background, this patch try to add stats support
>> for it, output is something like:
>>
>> $ cat /sys/fs/ext4/vda/lazyinit_stats
>> groups_finished: 80
>> groups_total: 80
>
> A few thoughts:
>
> If this goes in, it should be documented in
> Documentation/fs/ext4.txt, as well.
>
> I suppose it might be nice, but when do you think this
> might be needed in real life?

In our performances benchmarking, we want to wait
Lazyinit finished before starting really benchmarking sometimes.
(Since Lazyinit thread trigger some write background here)

but there is no way to see what is progress of lazyinit.
and we can only make sure there is no write from Device
counter...

>
> Also: sysfs is technically supposed to be one value per
> file, and (I think) just a number, no text.  At least,
> that's what every other ext4 device sysfs file has today,
> so this should follow that precedent.
>
> And as far as I can tell, "groups total" is the total
> uninit groups at mount time, not total  in the filesystem,
> so this would change on a remount? I think that's unexpected,
> and not very useful.

Yeah, From our usage, we need know progress of lazyiniting.
So after remoutning, 'total' will be dynamically changed.

We could store 'total' in superblock etc, but IMO it is
a bit overhead here.

>
> Simply printing the remaining uninitialized block group
> count might be enough, i.e.:
>
> $ cat /sys/fs/ext4/vda/lazyinit_remaining
> 42

Yup, this works fine for me.

Thank you for your coments!

>
> -Eric
>
>> Signed-off-by: Wang Shilong <wshilong@ddn.com>
>> ---
>> Sorry if you received twice, first one is blocked by
>> mail list.
>> ---
>>  fs/ext4/ext4.h  |    4 ++++
>>  fs/ext4/super.c |   19 ++++++++++++++++---
>>  fs/ext4/sysfs.c |   20 ++++++++++++++++++++
>>  3 files changed, 40 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 349afeb..9aaae81 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1505,6 +1505,10 @@ struct ext4_sb_info {
>>       struct ratelimit_state s_err_ratelimit_state;
>>       struct ratelimit_state s_warning_ratelimit_state;
>>       struct ratelimit_state s_msg_ratelimit_state;
>> +
>> +     /* for lazyinit stats */
>> +     unsigned long lazyinit_finished_cnt;
>> +     unsigned long lazyinit_total_cnt;
>>  };
>>
>>  static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 304c712..b95e622 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2660,6 +2660,7 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
>>               }
>>               elr->lr_next_sched = jiffies + elr->lr_timeout;
>>               elr->lr_next_group = group + 1;
>> +             EXT4_SB(sb)->lazyinit_finished_cnt++;
>>       }
>>       sb_end_write(sb);
>>
>> @@ -2864,10 +2865,12 @@ static struct ext4_li_request *ext4_li_request_new(struct super_block *sb,
>>  {
>>       struct ext4_sb_info *sbi = EXT4_SB(sb);
>>       struct ext4_li_request *elr;
>> +     ext4_group_t group, ngroups;
>> +     struct ext4_group_desc *gdp = NULL;
>>
>>       elr = kzalloc(sizeof(*elr), GFP_KERNEL);
>>       if (!elr)
>> -             return NULL;
>> +             return ERR_PTR(-ENOMEM);
>>
>>       elr->lr_super = sb;
>>       elr->lr_sbi = sbi;
>> @@ -2880,6 +2883,16 @@ static struct ext4_li_request *ext4_li_request_new(struct super_block *sb,
>>        */
>>       elr->lr_next_sched = jiffies + (prandom_u32() %
>>                               (EXT4_DEF_LI_MAX_START_DELAY * HZ));
>> +     ngroups = EXT4_SB(sb)->s_groups_count;
>> +      for (group = elr->lr_next_group; group < ngroups; group++) {
>         ^whitespace issue here
>> +             gdp = ext4_get_group_desc(sb, group, NULL);
>> +             if (!gdp) {
>> +                     elr = ERR_PTR(-EIO);
>> +                     break;
>> +             }
>> +             if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
>> +                     sbi->lazyinit_total_cnt++;
>> +     }
>>       return elr;
>>  }
>>
>> @@ -2907,8 +2920,8 @@ int ext4_register_li_request(struct super_block *sb,
>>               goto out;
>>
>>       elr = ext4_li_request_new(sb, first_not_zeroed);
>> -     if (!elr) {
>> -             ret = -ENOMEM;
>> +     if (IS_ERR(elr)) {
>> +             ret = PTR_ERR(elr);
>>               goto out;
>>       }
>>
>> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
>> index 1420a3c..8d0c199 100644
>> --- a/fs/ext4/sysfs.c
>> +++ b/fs/ext4/sysfs.c
>> @@ -20,6 +20,7 @@ typedef enum {
>>       attr_delayed_allocation_blocks,
>>       attr_session_write_kbytes,
>>       attr_lifetime_write_kbytes,
>> +     attr_lazyinit_stats,
>>       attr_reserved_clusters,
>>       attr_inode_readahead,
>>       attr_trigger_test_error,
>> @@ -72,6 +73,21 @@ static ssize_t lifetime_write_kbytes_show(struct ext4_attr *a,
>>                         EXT4_SB(sb)->s_sectors_written_start) >> 1)));
>>  }
>>
>> +static ssize_t lazyinit_stats_show(struct ext4_attr *a,
>> +                                struct ext4_sb_info *sbi, char *buf)
>> +{
>> +     int len = 0;
>> +     unsigned long total = sbi->lazyinit_total_cnt;
>> +     unsigned long finish = sbi->lazyinit_finished_cnt;
>> +
>> +     len += snprintf(buf + len, PAGE_SIZE,
>> +                     "groups_finished: %lu\n", finish);
>> +     len += snprintf(buf + len, PAGE_SIZE,
>> +                     "groups_total: %lu\n", total);
>> +
>> +     return len;
>> +}
>> +
>>  static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
>>                                         struct ext4_sb_info *sbi,
>>                                         const char *buf, size_t count)
>> @@ -165,6 +181,7 @@ static struct ext4_attr ext4_attr_##_name = {                     \
>>  EXT4_ATTR_FUNC(delayed_allocation_blocks, 0444);
>>  EXT4_ATTR_FUNC(session_write_kbytes, 0444);
>>  EXT4_ATTR_FUNC(lifetime_write_kbytes, 0444);
>> +EXT4_ATTR_FUNC(lazyinit_stats, 0444);
>>  EXT4_ATTR_FUNC(reserved_clusters, 0644);
>>
>>  EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, inode_readahead,
>> @@ -195,6 +212,7 @@ static struct attribute *ext4_attrs[] = {
>>       ATTR_LIST(delayed_allocation_blocks),
>>       ATTR_LIST(session_write_kbytes),
>>       ATTR_LIST(lifetime_write_kbytes),
>> +     ATTR_LIST(lazyinit_stats),
>>       ATTR_LIST(reserved_clusters),
>>       ATTR_LIST(inode_readahead_blks),
>>       ATTR_LIST(inode_goal),
>> @@ -265,6 +283,8 @@ static ssize_t ext4_attr_show(struct kobject *kobj,
>>               return session_write_kbytes_show(a, sbi, buf);
>>       case attr_lifetime_write_kbytes:
>>               return lifetime_write_kbytes_show(a, sbi, buf);
>> +     case attr_lazyinit_stats:
>> +             return lazyinit_stats_show(a, sbi, buf);
>>       case attr_reserved_clusters:
>>               return snprintf(buf, PAGE_SIZE, "%llu\n",
>>                               (unsigned long long)
>>
>
