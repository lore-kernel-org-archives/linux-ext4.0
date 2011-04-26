From: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Subject: Re: Need of revoke mechanism in JBD
Date: Tue, 26 Apr 2011 16:17:12 +0530
Message-ID: <4DB6A2B0.7050708@gmail.com>
References: <4DB68257.4070407@gmail.com>	<BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com> <BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Ding Dinghua <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42810 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab1DZKmv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 06:42:51 -0400
Received: by pwi15 with SMTP id 15so357615pwi.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 03:42:50 -0700 (PDT)
In-Reply-To: <BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If I am thinking correctly, journal would be checkpointed  on filesystem 
unmount calls.
This implies the given scenario would be pretty rare.

ie first filesystem should be mounted in full-journal mode, and crashed 
prior to checkpoint.
then it should be remounted in no-journalled-data mode without recovery
and again remounted in full journalled mode with recovery.

Am I thinking on correct lines?

On Tuesday 26 April 2011 02:53 PM, Ding Dinghua wrote:
> I think it's not only a performance issue but more important, a
> correctness issue.
> Revoke table is used for preventing the wrong replay of journal which
> cause data corruption:
> If block A has been journalled its modification, committed to journal
> and hasn't been checkpointed,
> and in later transactions block A is freed and reused for data in
> no-journalled-data mode, then If
> we don't have revoke table which recording the releasing event, replay
> of journal will overwrite the new data,
> which causing data corruption.
>
> 2011/4/26 Yongqiang Yang<xiaoqiangnk@gmail.com>:
>> AFAIK, it can accelerate the recovering process.  If a block is in the
>> revoke table of a transaction t1 and t1 is committed, then the there
>> is no need to recover the block in transactions which is earlier than
>> t1.
>>
>> On Tue, Apr 26, 2011 at 4:29 PM, Niraj Kulkarni
>> <kulkarniniraj14@gmail.com>  wrote:
>>> Hi all,
>>>       I am new to fs development. I am trying to modify the journal structure
>>> of JBD. While analyzing the code, I could understand most of the things, but
>>> I am not able to understand the need of revoke mechanism. Can anybody
>>> enlighten me on this issue?
>>>
>>> Regards
>>> Niraj
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>

