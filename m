From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
Date: Fri, 02 Dec 2011 09:45:24 -0600
Message-ID: <4ED8F294.1010500@redhat.com>
References: <20111201070052.GA29708@july> <4ED7FA81.9090802@redhat.com> <CAH9JG2WYsybK6aTo3+S58JM568S_YG7YqhP2jfrQ4pQ12GA5UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu, tm@tao.ma,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab1LBPpd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Dec 2011 10:45:33 -0500
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

Why not just do smaller FITRIM commands in the background while the phone
is running?  Why do you want to trim the whole fs at boot time
in the first place?

-Eric

