From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
Date: Fri, 02 Dec 2011 09:30:47 -0600
Message-ID: <4ED8EF27.5060906@redhat.com>
References: <20111201070052.GA29708@july> <4ED7FA81.9090802@redhat.com> <CAH9JG2WYsybK6aTo3+S58JM568S_YG7YqhP2jfrQ4pQ12GA5UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu, tm@tao.ma,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1LBPa6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Dec 2011 10:30:58 -0500
In-Reply-To: <CAH9JG2WYsybK6aTo3+S58JM568S_YG7YqhP2jfrQ4pQ12GA5UQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/1/11 6:01 PM, Kyungmin Park wrote:
> On 12/2/11, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 12/1/11 1:00 AM, Kyungmin Park wrote:
>>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>>
>>> Now trim information doesn't stored at disk so every boot time. it's
>>> cleared.
>>> and do the trim all disk groups.
>>> But assume that it's already trimmed at previous time so don't need to
>>> trim it again. So set the intial state as trimmed.
>>>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>> index e2d8be8..97ef342 100644
>>> --- a/fs/ext4/mballoc.c
>>> +++ b/fs/ext4/mballoc.c
>>> @@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb,
>>> ext4_group_t group)
>>>  		goto err;
>>>  	}
>>>  	mark_page_accessed(page);
>>> +
>>> +	/*
>>> +	 * TRIM information is not stored at disk so set the initial
>>> +	 * state as trimmed. Since previous time it's already trimmed all
>>> +	 */
>>> +	EXT4_MB_GRP_SET_TRIMMED(this_grp);
>>
> Hi,
> 
>> Hm, so if there were freed but un-trimmed blocks at this point, we will
>> never trim them until we free _another_ block in the group, right?  That
>> might be a reasonable tradeoff, but it is somewhat surprising behavior.
>>
>> i.e. say we do:
>>
>> mount /mnt
>> rm -rf /mnt/very_big_file
>> umount /mnt
>>
>> mount /mnt
>> fitrim /mnt
> another word, you can run fitrim after rm -rf
> yes, it's trade-off.
> 
> In my case, phone scenario, no umount system and data partition. it's
> burden to trim at boot time. it has still slower boot time.
> some daemon or program run fitrm at filesystem. it consumes time and
> hurt other boot processes.
>>
>> then we won't trim anything at all, right, despite there being many
>> new free blocks?  Which would be rather unexpected.
>>
>> If we don't store the trimmed state on disk, I think we should
>> probably stick with the slower first-time trim, and the more obvious
>> behavior (all free blocks are always trimmed whenever a trim
>> command is issued).
> 
> Umm how do you think, introduce the trim force command for this?

One that ignores the state flag?  Maybe, but IMHO that's getting even
kludgier, or at least more complicated.  I think it will be difficult
getting that past the vfs folks.  "Here is a new flag which says that
when we issue a trim command, we really should issue the trim command,
even if we are issuing it on ext4, and ext4 hasn't kept proper track,
and defaults to assuming that there is no work to do on a trim."

If we don't have space on-disk for the state, then we are kind of stuck.

But marking groups as "trimmed" when they are not, thereby ignoring
subsequent trim commands, strikes me as a very surprising behavior for
the user.

-Eric

> Thank you,
> Kyungmin Park
>>
>> -Eric
>>
>>>  err:
>>>  	ext4_mb_put_buddy_page_lock(&e4b);
>>>  	return ret;
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>

