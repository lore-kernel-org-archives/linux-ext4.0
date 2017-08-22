From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH] ext4: fix incorrect quotaoff if the quota feature is
 enabled
Date: Tue, 22 Aug 2017 17:38:57 +0800
Message-ID: <5a483e73-3bfb-a4a9-ea0b-c68024d1c0e1@huawei.com>
References: <1503384097-19206-1-git-send-email-yi.zhang@huawei.com>
 <20170822092205.GA4909@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4989 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932295AbdHVJjK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Aug 2017 05:39:10 -0400
In-Reply-To: <20170822092205.GA4909@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2017/8/22 17:22, Jan Kara Wrote:
> On Tue 22-08-17 14:41:37, zhangyi (F) wrote:
>> Current ext4 quota should always "usage enabled" if the
>> quota feautre is enabled. But in ext4_orphan_cleanup(), it
>> turn quota off directly (used for the older quota), so
>> we cannot turn it on again via "quotaon" unless umount and
>> remount ext4.
>>
>> Simple reproduce:
>>
>>   mkfs.ext4 -O project,quota /dev/vdb1
>>   mount -o prjquota /dev/vdb1 /mnt
>>   chattr -p 123 /mnt
>>   chattr +P /mnt
>>   touch /mnt/aa /mnt/bb
>>   exec 100<>/mnt/aa
>>   rm -f /mnt/aa
>>   sync
>>   echo c > /proc/sysrq-trigger
>>
>>   #reboot and mount
>>   mount -o prjquota /dev/vdb1 /mnt
>>   #query status
>>   quotaon -Ppv /dev/vdb1
>>   #output
>>   quotaon: Cannot find mountpoint for device /dev/vdb1
>>   quotaon: No correct mountpoint specified.
>>
>> This patch avoid incorrect quotaoff when ext4 has quota
>> feautre. We also take care about the "quota on" part in
>> ext4_orphan_cleanup(), it is used for journalled quota
>> and not invoked if quota feature is enabled, so it's not
>> affected.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  fs/ext4/super.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index d61a70e2..c1b23b1 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2510,10 +2510,12 @@ static void ext4_orphan_cleanup(struct super_block *sb,
>>  		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
>>  		       PLURAL(nr_truncates));
>>  #ifdef CONFIG_QUOTA
>> -	/* Turn quotas off */
>> -	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
>> -		if (sb_dqopt(sb)->files[i])
>> -			dquot_quota_off(sb, i);
>> +	if (!ext4_has_feature_quota(sb)) {
>> +		/* Turn quotas off */
>> +		for (i = 0; i < EXT4_MAXQUOTAS; i++) {
>> +			if (sb_dqopt(sb)->files[i])
>> +				dquot_quota_off(sb, i);
>> +		}
> 
> So this should work however I'd prefer if we kept the test symmetric to the
> place where we turn quotas on for orphan cleanup. I.e. something like:
> 
> 	for (i = 0; i < EXT4_MAXQUOTAS; i++) {
> 		/* Old style journalled quotas enabled for orphan cleanup? */
> 		if (EXT4_SB(sb)->s_qf_names[i] && sb_dqopt(sb)->files[i])
> 			dquot_quota_off(sb, i);
> 	}
> 

Yes, looks better, good suggestion, thanks!

> Also when looking at this code I've noticed that quota does not get enabled
> if we use quota feature and we do orphan replay on read-only filesystem.
> Could you fix that by handling this case in ext4_orphan_cleanup() as well?
> Thanks!

Sure, I will fix it as well.

Thanks,
ZhangYi.
