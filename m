From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: Re: [PATCH] fs/ext4: fix potential endless loop in ext4_mb_discard_group_preallocations()
Date: Thu, 17 Sep 2015 09:27:44 +0800
Message-ID: <55FA1710.7080602@huawei.com>
References: <1441013790-87948-1-git-send-email-zhenzhang.zhang@huawei.com> <55E42270.9040503@huawei.com> <20150916194510.GC29530@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:48882 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbbIQB3H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2015 21:29:07 -0400
In-Reply-To: <20150916194510.GC29530@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2015/9/17 3:45, Jan Kara wrote:
> On Mon 31-08-15 17:46:24, Zhang Zhen wrote:
>> In ext4_mb_discard_group_preallocations(), if free is always less than needed,
>> and some PAs are always used in every loop, it will be endless loop.
>>
>> Here we pick a random value to limit the max number of loop.
> 
> Were you able to trigger this in practice or is it just a theoretical
> concern?
> 
We found the problem in a stress test.
It lead to system hungtask.

Thanks!
> My slight concern is that in theory we could prematurely declare ENOSPC
> with this patch since ext4_mb_discard_preallocations() doesn't reliably
> discard all the preallocations anymore. But probably that's acceptable.
> But we should add a comment before ext4_mb_discard_group_preallocations()
> saying that the functions needn't free all the preallocations.
> 
> 								Honza
>>
>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
>> ---
>>  fs/ext4/mballoc.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 34b610e..553fbde 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -3836,6 +3836,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
>>  	int err;
>>  	int busy = 0;
>>  	int free = 0;
>> +	int tried = 0;
>>
>>  	mb_debug(1, "discard preallocation for group %u\n", group);
>>
>> @@ -3886,9 +3887,11 @@ repeat:
>>  		list_add(&pa->u.pa_tmp_list, &list);
>>  	}
>>
>> -	/* if we still need more blocks and some PAs were used, try again */
>> -	if (free < needed && busy) {
>> +	/* if we still need more blocks and some PAs were used, try again,
>> +	   here 20 is a ramdon value. */
>> +	if (free < needed && busy && tried < 20) {
>>  		busy = 0;
>> +		tried++;
>>  		ext4_unlock_group(sb, group);
>>  		cond_resched();
>>  		goto repeat;
>> -- 
>> 1.9.1
>>
>>
>> .
>>
>>
>>
>>


