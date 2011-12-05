From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
Date: Mon, 5 Dec 2011 19:35:55 +0900
Message-ID: <CAH9JG2WrrO105AeSwoZ9DCt3dyvqYuoefVZZJhx1YgHAFrTpCA@mail.gmail.com>
References: <20111201070052.GA29708@july>
	<alpine.LFD.2.00.1112051106070.4911@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, tm@tao.ma, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55633 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1LEKf4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 05:35:56 -0500
In-Reply-To: <alpine.LFD.2.00.1112051106070.4911@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/5/11, Lukas Czerner <lczerner@redhat.com> wrote:
> On Thu, 1 Dec 2011, Kyungmin Park wrote:
>
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> Now trim information doesn't stored at disk so every boot time. it's
>> cleared.
>> and do the trim all disk groups.
>> But assume that it's already trimmed at previous time so don't need to
>> trim it again. So set the intial state as trimmed.
>
> Hi,
>
> I am sorry, but from the code and comments I have seen, I do not think
> it does make sense to change that behaviour. I agree that discarding the
> whole file system after the mount might not be necessarily needed, but
> on the other hand, you can never assume that the blocks were already
> trimmed, since it most likely will not be true.
>
> I think that the bigger problem is "running fitrim at boot time" which
> does not make sense to me, because you'll be perfectly fine leaving this
> up to the cron (or something similar). Also when you're booting you need
> to be done ASAP so why to bother with other unnecessary operations ?

Okay please ignore the boot time, but still first trim operation needs
to be considered.
Unlike the pc world, the phone is turned off/on frequently. at that
time it trims all block again.
I know it's not hurt the flash life time, but want to avoid to useless
trim operation on flash.

Yes, the best solution is that trim information is also stored at disk.
Can you confirm the idea? store the trim information at bg_flags at
struct ext4_block_desc?

Thank you,
Kyungmin Park
>
> The funniest thing about this patch is (no offense, really) that you've
> solved the problem of "fitrim slowing down the boot process" by changing
> kernel logic to assume something which will most likely be false, instead
> of just *not* doing boot time fitrim at the first place, because this is
> exactly what will happen with this patch.
>
> Thanks!
> -Lukas
>
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
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
>
