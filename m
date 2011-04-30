From: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Subject: Re: Need of revoke mechanism in JBD
Date: Sat, 30 Apr 2011 07:36:49 +0530
Message-ID: <4DBB6EB9.40100@gmail.com>
References: <4DB68257.4070407@gmail.com>	<BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>	<BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>	<20110426122558.GF9486@thunk.org> <BANLkTin35yOg+ndy3i4vTT7RHxtFso+HCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Ding Dinghua <dingdinghua85@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33945 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1D3CG6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Apr 2011 22:06:58 -0400
Received: by pvg12 with SMTP id 12so2515450pvg.19
        for <linux-ext4@vger.kernel.org>; Fri, 29 Apr 2011 19:06:58 -0700 (PDT)
In-Reply-To: <BANLkTin35yOg+ndy3i4vTT7RHxtFso+HCA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday 30 April 2011 01:15 AM, Amir Goldstein wrote:
> On Tue, Apr 26, 2011 at 3:25 PM, Ted Ts'o<tytso@mit.edu>  wrote:
>> On Tue, Apr 26, 2011 at 05:23:21PM +0800, Ding Dinghua wrote:
>>> I think it's not only a performance issue but more important, a
>>> correctness issue.
>>> Revoke table is used for preventing the wrong replay of journal which
>>> cause data corruption:
>>> If block A has been journalled its modification, committed to journal
>>> and hasn't been checkpointed,
>>> and in later transactions block A is freed and reused for data in
>>> no-journalled-data mode, then If
>>> we don't have revoke table which recording the releasing event, replay
>>> of journal will overwrite the new data,
>>> which causing data corruption.
>> Yes, this is correct.  It should be covered fairly well in Stephen
>> Tweedie's, "Journaling the ext2fs file system" paper, which you can
>> find at:
>>
>> https://ext4.wiki.kernel.org/index.php/Publications
> Actually, the original paper has no mention of revoke records.
> I went out to look for useful documentation on journal forget/revoke
> and came back empty handed as well.
>
>> if you'd like more details.
>>
>> Hope this helps!
>>
>>                                                 - Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
Yes, I tried some other papers too, but no use. Anyway I've figured out 
that for my change, I dont need any kind of journalling related 
facilities, so I am going to bypass it completely.

Niraj
