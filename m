From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
Date: Thu, 1 Dec 2011 17:19:16 +0900
Message-ID: <CAH9JG2UADvsPX0s8TYTZ29j92AwDkVAGOhCwM-VFXQOP5yF7rA@mail.gmail.com>
References: <20111201070052.GA29708@july>
	<4ED72F1D.7070207@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62393 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1LAITS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2011 03:19:18 -0500
In-Reply-To: <4ED72F1D.7070207@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/1/11, Tao Ma <tm@tao.ma> wrote:
> Hi Kyungmin,
> On 12/01/2011 03:00 PM, Kyungmin Park wrote:
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> Now trim information doesn't stored at disk so every boot time. it's
>> cleared.
>> and do the trim all disk groups.
>> But assume that it's already trimmed at previous time so don't need to
>> trim it again. So set the intial state as trimmed.
> sorry, I don't get your meaning here.
> Why can we assume that the group is already trimmed since it isn't
> stored in the disk?
To avoid the first time trim operation.
Every boot time. run the fitrim then it trims all block groups again.
but it's already done at previous time. so don't need to trim it
again.
Doesn't make sense? I think it's not designed behavior.

In your patch at http://patchwork.ozlabs.org/patch/102918/

with the patch:
[root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
real	0m5.625s
user	0m0.000s
sys	0m1.269s
[root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
real	0m0.002s
user	0m0.000s
sys	0m0.001s
[root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
real	0m0.002s
user	0m0.000s
sys	0m0.001s

After reboot. it maybe become below

[root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
real	0m0.002s
user	0m0.000s
sys	0m0.001s
[root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
real	0m0.002s
user	0m0.000s
sys	0m0.001s
[root@boyu-tm linux-2.6]# time ./ftrim /mnt/ext4/a
real	0m0.002s
user	0m0.000s
sys	0m0.001s

Thank you,
Kyungmin Park
>
> Thanks
> Tao
>>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index e2d8be8..97ef342 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb,
>> ext4_group_t group)
>>  		goto err;
>>  	}
>>  	mark_page_accessed(page);
>> +
>> +	/*
>> +	 * TRIM information is not stored at disk so set the initial
>> +	 * state as trimmed. Since previous time it's already trimmed all
>> +	 */
>> +	EXT4_MB_GRP_SET_TRIMMED(this_grp);
>>  err:
>>  	ext4_mb_put_buddy_page_lock(&e4b);
>>  	return ret;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
