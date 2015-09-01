From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: Re: [PATCH] fs/ext4: fix potential endless loop in ext4_mb_discard_group_preallocations()
Date: Tue, 1 Sep 2015 09:16:38 +0800
Message-ID: <55E4FC76.1090609@huawei.com>
References: <1441013790-87948-1-git-send-email-zhenzhang.zhang@huawei.com> <55E42270.9040503@huawei.com> <0E3B5981-84C9-474C-91C2-311CB8B85C24@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	<adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:52375 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbbIABQw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2015 21:16:52 -0400
In-Reply-To: <0E3B5981-84C9-474C-91C2-311CB8B85C24@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2015/9/1 6:34, Andreas Dilger wrote:
> On Aug 31, 2015, at 3:46 AM, Zhang Zhen <zhenzhang.zhang@huawei.com> wrote:
>>
>> In ext4_mb_discard_group_preallocations(), if free is always less
>> than needed, and some PAs are always used in every loop, it will
>> be endless loop.
>>
>> Here we pick a random value to limit the max number of loop.
>>
>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
>> ---
>> fs/ext4/mballoc.c | 7 +++++--
>> 1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 34b610e..553fbde 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -3836,6 +3836,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
>> 	int err;
>> 	int busy = 0;
>> 	int free = 0;
>> +	int tried = 0;
>>
>> 	mb_debug(1, "discard preallocation for group %u\n", group);
>>
>> @@ -3886,9 +3887,11 @@ repeat:
>> 		list_add(&pa->u.pa_tmp_list, &list);
>> 	}
>>
>> -	/* if we still need more blocks and some PAs were used, try again */
>> -	if (free < needed && busy) {
>> +	/* if we still need more blocks and some PAs were used, try again,
>> +	   here 20 is a ramdon value. */
> 
> (typo) s/ramdon/random/
> 
My mistake, thanks!

>> +	if (free < needed && busy && tried < 20) {
>> 		busy = 0;
>> +		tried++;
>> 		ext4_unlock_group(sb, group);
>> 		cond_resched();
>> 		goto repeat;
> 
> Looks OK otherwise.
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> 
> 


