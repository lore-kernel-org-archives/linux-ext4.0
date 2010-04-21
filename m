From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Wed, 21 Apr 2010 15:04:51 -0400
Message-ID: <4BCF4C53.3010608@redhat.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	 <1271674527-2977-2-git-send-email-lczerner@redhat.com>	 <1271674527-2977-3-git-send-email-lczerner@redhat.com>	 <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>	 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com> <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Mark Lord <kernel@teksavvy.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab0DUTCU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 15:02:20 -0400
In-Reply-To: <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/21/2010 02:59 PM, Greg Freemyer wrote:
> On Tue, Apr 20, 2010 at 10:45 PM, Eric Sandeen<sandeen@redhat.com>  wrote:
>> Mark Lord wrote:
>>> On 20/04/10 05:21 PM, Greg Freemyer wrote:
>>>> Mark,
>>>>
>>>> This is the patch implementing the new discard logic.
>>> ..
>>>> Signed-off-by: Lukas Czerner<lczerner@redhat.com>
>>> ..
>>>>> +void ext4_trim_extent(struct super_block *sb, int start, int count,
>>>>> +               ext4_group_t group, struct ext4_buddy *e4b)
>>>>> +{
>>>>> +       ext4_fsblk_t discard_block;
>>>>> +       struct ext4_super_block *es = EXT4_SB(sb)->s_es;
>>>>> +       struct ext4_free_extent ex;
>>>>> +
>>>>> +       assert_spin_locked(ext4_group_lock_ptr(sb, group));
>>>>> +
>>>>> +       ex.fe_start = start;
>>>>> +       ex.fe_group = group;
>>>>> +       ex.fe_len = count;
>>>>> +
>>>>> +       mb_mark_used(e4b,&ex);
>>>>> +       ext4_unlock_group(sb, group);
>>>>> +
>>>>> +       discard_block = (ext4_fsblk_t)group *
>>>>> +                       EXT4_BLOCKS_PER_GROUP(sb)
>>>>> +                       + start
>>>>> +                       + le32_to_cpu(es->s_first_data_block);
>>>>> +       trace_ext4_discard_blocks(sb,
>>>>> +                       (unsigned long long)discard_block,
>>>>> +                       count);
>>>>> +       sb_issue_discard(sb, discard_block, count);
>>>>> +
>>>>> +       ext4_lock_group(sb, group);
>>>>> +       mb_free_blocks(NULL, e4b, start, ex.fe_len);
>>>>> +}
>>>>
>>>> Mark, unless I'm missing something, sb_issue_discard() above is going
>>>> to trigger a trim command for just the one range.  I thought the
>>>> benchmarks you did showed that a collection of ranges needed to be
>>>> built, then a single trim command invoked that trimmed that group of
>>>> ranges.
>>> ..
>>>
>>> Mmm.. If that's what it is doing, then this patch set would be a
>>> complete disaster.
>>> It would take *hours* to do the initial TRIM.
>>>
>>> Lukas ?
>>
>> I'm confused; do we have an interface to send a trim command for multiple ranges?
>>
>> I didn't think so ...  Lukas' patch is finding free ranges (above a size threshold)
>> to discard; it's not doing it a block at a time, if that's the concern.
>>
>> -Eric
>
> Eric,
>
> I don't know what kernel APIs have been created to support discard,
> but the ATA8 draft spec. allows for specifying multiple ranges in one
> trim command.
>

Greg,

We have full support for this in the "discard" support at the file system layer 
for several file systems.

The block layer effectively muxes the "discard" into the right target device 
command. TRIM for ATA, WRITE_SAME (with unmap) or UNMAP for SCSI...

If your favourite fs supports this, you can enable this feature with "-o 
discard" for fine grained discards,

ric
