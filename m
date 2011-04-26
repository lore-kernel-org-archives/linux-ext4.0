From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Need of revoke mechanism in JBD
Date: Tue, 26 Apr 2011 13:57:48 +0300
Message-ID: <BANLkTikJpb8je2UUXhav6rAF7UKaMc6KjQ@mail.gmail.com>
References: <4DB68257.4070407@gmail.com>
	<BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
	<BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
	<4DB6A2B0.7050708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ding Dinghua <dingdinghua85@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37995 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1DZK5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 06:57:49 -0400
Received: by eyx24 with SMTP id 24so143739eyx.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 03:57:48 -0700 (PDT)
In-Reply-To: <4DB6A2B0.7050708@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2011 at 1:47 PM, Niraj Kulkarni
<kulkarniniraj14@gmail.com> wrote:
> If I am thinking correctly, journal would be checkpointed =A0on files=
ystem
> unmount calls.
> This implies the given scenario would be pretty rare.
>
> ie first filesystem should be mounted in full-journal mode, and crash=
ed
> prior to checkpoint.
> then it should be remounted in no-journalled-data mode without recove=
ry
> and again remounted in full journalled mode with recovery.
>
> Am I thinking on correct lines?

nope.
first the block is allocated as metadata and journaled.
then the metadata block is freed and re-allocated as non-journaled data=
=2E
this is the use case and it would be very easy to corrupt data if it wa=
sn't
for journal revoke.

Amir.

>
> On Tuesday 26 April 2011 02:53 PM, Ding Dinghua wrote:
>>
>> I think it's not only a performance issue but more important, a
>> correctness issue.
>> Revoke table is used for preventing the wrong replay of journal whic=
h
>> cause data corruption:
>> If block A has been journalled its modification, committed to journa=
l
>> and hasn't been checkpointed,
>> and in later transactions block A is freed and reused for data in
>> no-journalled-data mode, then If
>> we don't have revoke table which recording the releasing event, repl=
ay
>> of journal will overwrite the new data,
>> which causing data corruption.
>>
>> 2011/4/26 Yongqiang Yang<xiaoqiangnk@gmail.com>:
>>>
>>> AFAIK, it can accelerate the recovering process. =A0If a block is i=
n the
>>> revoke table of a transaction t1 and t1 is committed, then the ther=
e
>>> is no need to recover the block in transactions which is earlier th=
an
>>> t1.
>>>
>>> On Tue, Apr 26, 2011 at 4:29 PM, Niraj Kulkarni
>>> <kulkarniniraj14@gmail.com> =A0wrote:
>>>>
>>>> Hi all,
>>>> =A0 =A0 =A0I am new to fs development. I am trying to modify the j=
ournal
>>>> structure
>>>> of JBD. While analyzing the code, I could understand most of the t=
hings,
>>>> but
>>>> I am not able to understand the need of revoke mechanism. Can anyb=
ody
>>>> enlighten me on this issue?
>>>>
>>>> Regards
>>>> Niraj
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>>
>>> --
>>> Best Wishes
>>> Yongqiang Yang
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
